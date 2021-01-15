<?php
defined('BASEPATH') or exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';
require APPPATH . '/libraries/LogWrite.php';

class Loan extends CI_Controller
{
    public function apply()
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
                    $this->load->model('Model_loan');

                    $is_valid_param = $this->Model_loan->validateParamsForLoan($parsed['data']);

                    if ($is_valid_param['status_code'] == "ALLOK1") {
                        $unserialized = unserialize(base64_decode($parsed['data']['type']), ["LogWrite"]);
                        $this->Model_loan->saveLoanDetails($account_id, $parsed['data'], $unserialized);
                        echo prepare_response(
                            "Success",
                            $status::LoanSuccess['status_code'],
                            $status::LoanSuccess['message'],
                            time(),
                            (object)array()
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

    public function index()
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
                    $this->load->model('Model_loan');
                    $is_valid_param = $this->Model_loan->getLoanDetails($account_id);
                    if ($is_valid_param['status_code'] == "ALLOK1") {

                        echo prepare_response(
                            "Success",
                            $status::LoanSuccess['status_code'],
                            $status::LoanSuccess['message'],
                            time(),
                            $is_valid_param['data']
                        );
                    } else {
                        echo prepare_response(
                            "Failed",
                            $is_valid_param['status_code'],
                            $is_valid_param['message'],
                            time(),
                            array()
                        );
                    }
                } else {
                    echo prepare_response(
                        "Failed",
                        $status::InvalidSession['status_code'],
                        $status::InvalidSession['message'],
                        time(),
                        array()
                    );
                }
            } else {
                echo prepare_response(
                    "Failed",
                    $status::RequestParameterNotSet['status_code'],
                    $status::RequestParameterNotSet['message'],
                    time(),
                    array()
                );
            }
        }
    }
}
