<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Logout extends CI_Controller
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
            $this->load->model('LogoutModuleHandler');
            $is_valid_param = $this->LogoutModuleHandler->validateParams($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $result = $this->LogoutModuleHandler->logout_user($parsed);
                if ($result['status_code'] == "ALLOK2") {
                    echo prepare_response(
                        'Success',
                        $status::LogoutSuccess['status_code'],
                        $status::LogoutSuccess['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    echo prepare_response(
                        'Success',
                        $result['status_code'],
                        $result['message'],
                        time(),
                        (object)array()
                    );
                } 
            } else {
                echo prepare_response(
                    'Failed',
                    $is_valid_param['status_code'],
                    $is_valid_param['message'],
                    time(),
                    (object)array()
                );
            }
        }
    }
}
