<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Otp extends CI_Controller
{

    public function get()
    {

        $this->load->helper('request_response');
        $status = new status_codes();

        $parsed = request_parse();
        if ($parsed['status_code'] != 'ALLOK1') {
            echo prepare_response(
                'Failed',
                $parsed['status_code'],
                $parsed['message'],
                time(),
                (object)array()
            );
        } else {
            $this->load->helper('session');
            // check for valid user session
            $token = get_sessionId($parsed);
            if ($token != null) {
                $account_id = is_valid_session($token);
                if ($account_id != null) {
                    $this->load->model('Model_otp');
                    $is_valid_param = $this->Model_otp->validateParamsForGet($parsed);
                    if ($is_valid_param['status_code'] == "ALLOK1") {
                        echo prepare_response(
                            "Success",
                            $status::OtpGenerated['status_code'],
                            $status::OtpGenerated['message'],
                            time(),
                            (object) $this->Model_otp->generate(
                                $account_id,
                                $parsed
                            )
                        );
                    } else {
                        echo prepare_response(
                            "Failed",
                            $is_valid_param['status_code'],
                            $is_valid_param['message'],
                            time(),
                            (object)array()
                        );
                    }
                } else {
                    echo prepare_response(
                        "Failed",
                        $status::InvalidSession['status_code'],
                        $status::InvalidSession['message'],
                        time(),
                        (object)array()
                    );
                }
            } else {
                echo prepare_response(
                    "Failed",
                    $status::RequestParameterNotSet['status_code'],
                    $status::RequestParameterNotSet['message'],
                    time(),
                    (object)array()
                );
            }
        }
    }

    public function verify()
    {
        $this->load->helper('request_response');
        $status = new status_codes();

        $parsed = request_parse();
        if ($parsed['status_code'] != 'ALLOK1') {
            echo prepare_response(
                'Failed',
                $parsed['status_code'],
                $parsed['message'],
                time(),
                (object)array()
            );
        } else {
            $this->load->helper('session');
            // check for valid user session
            $token = get_sessionId($parsed);
            if ($token != null) {
                $account_id = is_valid_session($token);
                if ($account_id != null) {
                    $this->load->model('Model_otp');
                    $is_valid_param = $this->Model_otp->validateParamsForVerify($parsed);
                    if ($is_valid_param['status_code'] == "ALLOK1") {
                        $otp_status = $this->Model_otp->check_otp($account_id, $parsed);
                        if ($otp_status['attempts'] == -1) {
                            echo prepare_response(
                                "Success",
                                $status::OtpVerifySuccess['status_code'],
                                $status::OtpVerifySuccess['message'],
                                time(),
                                array(
                                    "response" => $otp_status['response']
                                )
                            );
                        } elseif ($otp_status['attempts'] == -2) {
                            echo prepare_response(
                                "Failed",
                                $status::OtpVerifyNull['status_code'],
                                $status::OtpVerifyNull['message'],
                                time(),
                                (object)array()
                            );
                        } else if($otp_status['otp_type'] == 3){
                            echo prepare_response(
                                "Failed",
                                $status::OtpVerifyFailed['status_code'],
                                $status::OtpVerifyFailed['message'],
                                time(),
                                array(
                                    
                                )
                            );
                        }else {
                            echo prepare_response(
                                "Failed",
                                $status::OtpVerifyFailed['status_code'],
                                $status::OtpVerifyFailed['message'],
                                time(),
                                array(
                                    "response" => "Attempts Remaining: " . $otp_status['attempts']
                                )
                            );
                        }
                    } else { echo prepare_response(
                        "Failed",
                        $is_valid_param['status_code'],
                        $is_valid_param['message'],
                        time(),
                        (object)array()
                        );
                    }
                } else { echo prepare_response(
                    "Failed",
                    $status::InvalidSession['status_code'],
                    $status::InvalidSession['message'],
                    time(),
                    (object)array()
                    );
                }
            } else { echo prepare_response(
                "Failed",
                $status::RequestParameterNotSet['status_code'],
                $status::RequestParameterNotSet['message'],
                time(),
                (object)array()
                );
            }
        }
    }

}

?>
