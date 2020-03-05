<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Signup extends CI_Controller
{
    public function checkAvailability()
    {
        $this->load->helper('request_response');
        $this->load->model('SignUpModuleHandler');
        $status = new status_codes();
        $parsed = request_parse();
        if ($parsed['status_code'] != 'ALLOK1') {
            echo prepare_response(
                'Failed',
                $parsed['status_code'],
                $parsed['message'],
                time(),
                (object) array()
            );
        } else {
            $is_valid_param = $this->SignUpModuleHandler->validateParamsForExist($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $result = $this->SignUpModuleHandler->mobile_or_email_exists($parsed);
                if ($result['status_code'] == "ALLOK2") {
                    echo prepare_response(
                        "Success",
                        $status::MobileAndEmailNotExist['status_code'],
                        $status::MobileAndEmailNotExist['message'],
                        time(),
                        (object) array("result" => $result['result'])
                    );
                } else {
                    echo prepare_response(
                        "Success",
                        $result['status_code'],
                        $result['message'],
                        time(),
                        (object) array("result" => $result['result'])
                    );
                }
            } else {
                echo prepare_response(
                    "Failed",
                    $is_valid_param['status_code'],
                    $is_valid_param['message'],
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
                (object) array()
            );
        } else {
            $this->load->model('SignUpModuleHandler');
            $params = $this->SignUpModuleHandler->validateSignUpAPIParameter($parsed['data']);
            if ($params['status_code'] == "ALLOK1") {
                echo prepare_response(
                    "Success",
                    $status::SignupSuccess['status_code'],
                    $status::SignupSuccess['message'],
                    time(),
                    $this->SignUpModuleHandler->signup_user($parsed)
                );
            } else {
                echo prepare_response(
                    "Failed",
                    $params['status_code'],
                    $params['message'],
                    time(),
                    (object)array()
                );
            }
        }
    }
}
