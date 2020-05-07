<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Password extends CI_Controller
{

	public function forgot()
	{
		$this->load->helper('request_response');
		$status = new status_codes();

		$parsed = request_parse();
		if ($parsed['status_code'] != 'ALLOK1')
			echo prepare_response(
				'Failed',
				$parsed['status_code'],
				$parsed['message'],
				time(),
				(object)array()
			);
		else {
			$this->load->model('Model_otp');
			$is_valid_param = $this->Model_otp->validateParamsForForgot($parsed);
			if ($is_valid_param['status_code'] == "ALLOK1") {
				$this->load->model('Model_passwd');
				$account_id = $this->Model_passwd->get_accountid($parsed);
				if ($account_id == NULL)
					echo prepare_response(
						"Failed",
						$status::Unregistered['status_code'],
						$status::Unregistered['message'],
						time(),
						(object)array()
					);
				else
					echo prepare_response(
						"Success",
						$status::OtpGenerated['status_code'],
						$status::OtpGenerated['message'],
						time(),
						(object) $this->Model_otp->generate(
							$account_id, $parsed
						)
					);
			} else
				echo prepare_response(
					"Failed",
					$is_valid_param['status_code'],
					$is_valid_param['message'],
					time(),
					(object)array()
				);
		}
	}

	public function reset()
	{
		$this->load->helper('request_response');
		$status = new status_codes();

		$parsed = request_parse();
		if ($parsed['status_code'] != 'ALLOK1')
			echo prepare_response(
				'Failed',
				$parsed['status_code'],
				$parsed['message'],
				time(),
				(object)array()
			);
		else {
			$this->load->model('Model_passwd');
			$is_valid_param = $this->Model_passwd->validateParamsForReset($parsed);
			$account_id = $this->Model_passwd->get_accountid($parsed);
			if ($is_valid_param['status_code'] == "ALLOK1") {
				$reset_status = $this->Model_passwd->reset_user_passwd($account_id, $parsed);
				if ($reset_status['status_code'] == "ALLOK2")
					echo prepare_response(
						"Success",
						$status::PasswordResetSuccess['status_code'],
						$status::PasswordResetSuccess['message'],
						time(),
						(object)array()
					);
				else
					echo prepare_response(
						"Failed",
						$reset_status['status_code'],
						$reset_status['message'],
						time(),
						(object)array()
					);
			} else echo prepare_response(
				"Failed",
				$is_valid_param['status_code'],
				$is_valid_param['message'],
				time(),
				(object)array()
			);
		}
	}

	public function verifyuser()
	{
		$this->load->helper('request_response');
		$status = new status_codes();

		$parsed = request_parse();
		if ($parsed['status_code'] != 'ALLOK1')
			echo prepare_response(
				'Failed',
				$parsed['status_code'],
				$parsed['message'],
				time(),
				(object)array()
			);
		else {
			$this->load->model('Model_otp');
			$this->load->model('Model_passwd');
			$is_valid_param = $this->Model_otp->validateParamsForVerify1($parsed);
			if ($is_valid_param['status_code'] == "ALLOK1") {
				$account_id = $this->Model_passwd->get_accountid($parsed);
				$otp_status = $this->Model_otp->check_otp($account_id, $parsed);
				if ($otp_status['attempts'] == -1)
					echo prepare_response(
						"Success",
						$status::OtpVerifySuccess['status_code'],
						$status::OtpVerifySuccess['message'],
						time(),
						array(
							"response" => $otp_status['response']
						)
					);
				elseif ($otp_status['attempts'] == -2)
					echo prepare_response(
						"Failed",
						$status::OtpVerifyNull['status_code'],
						$status::OtpVerifyNull['message'],
						time(),
						(object)array()
					);
				else
					echo prepare_response(
						"Failed",
						$status::OtpVerifyFailed['status_code'],
						$status::OtpVerifyFailed['message'],
						time(),
						array(
							"response" => "Attempts Remaining: " . $otp_status['attempts']
						)
					);
			} else echo prepare_response(
				"Failed",
				$is_valid_param['status_code'],
				$is_valid_param['message'],
				time(),
				(object)array()
			);
		}
	}

	public function change()
	{
		$this->load->helper('request_response');
		$status = new status_codes();

		$parsed = request_parse();
		if ($parsed['status_code'] != 'ALLOK1')
			echo prepare_response(
				'Failed',
				$parsed['status_code'],
				$parsed['message'],
				time(),
				(object)array()
			);
		else {
			$this->load->model('Model_passwd');
			$is_valid_param = $this->Model_passwd->validateParamsForChange($parsed['data']);
			if ($is_valid_param['status_code'] == "ALLOK1") {
				$change_status = $this->Model_passwd->change_passwd($parsed);
				if ($change_status['status_code'] == "ALLOK2")
					echo prepare_response(
						"Success",
						$status::ChangePasswdSuccess['status_code'],
						$status::ChangePasswdSuccess['message'],
						time(),
						(object)array()
					);
				else
					echo prepare_response(
						"Failed",
						$change_status['status_code'],
						$change_status['message'],
						time(),
						(object)array()
					);
			} else echo prepare_response(
				"Failed",
				$is_valid_param['status_code'],
				$is_valid_param['message'],
				time(),
				(object)array()
			);
		}
	}
}


?>
