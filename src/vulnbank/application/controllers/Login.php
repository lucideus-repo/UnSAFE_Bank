<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Login extends CI_Controller
{

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
            return false;
        } else {
            $this->load->model('LoginModuleHandler');
            $isValidParam = $this->LoginModuleHandler->validateLoginAPIParameter($parsed);
            if ($isValidParam['status_code'] == "ALLOK1") {
                $result = $this->LoginModuleHandler->login_user($parsed);
                if ($result['status_code'] == "ALLOK2") {
                    echo prepare_response(
                        "Success",
                        $status::LoginSuccess['status_code'],
                        $status::LoginSuccess['message'],
                        time(),
                        $result['data']
                    );
                } else {
                    echo prepare_response(
                        "Failed",
                        $result['status_code'],
                        $result['message'],
                        time(),
                        (object)array()
                    );
                }
            } else {
                echo prepare_response(
                    "Failed",
                    $isValidParam['status_code'],
                    $isValidParam['message'],
                    time(),
                    (object)array()
                );
            }
        }
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
            return false;
        }
    }
}

?>
