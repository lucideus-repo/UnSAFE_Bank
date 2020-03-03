<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Account extends CI_Controller
{
    public function statement()
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
            $this->load->model('Model_statement');
            $is_valid_param = $this->Model_statement->validate_all($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $get_result = $this->Model_statement->get_all($parsed);
                if ($get_result['status_code'] != "ALLOK2") {
                    echo prepare_response(
                        "Failed",
                        $get_result['status_code'],
                        $get_result['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    echo prepare_response(
                        "Success",
                        $status::TranStatement['status_code'],
                        $status::TranStatement['message'],
                        time(),
                        (object) array(
                            "statement" => $get_result['data']
                        )
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
        echo "API Path is not functional";
    }

    public function details()
    {
        $this->load->helper('request_response');
        $this->load->model('model_my_account');
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
            $is_valid_param = $this->model_my_account->validateParamsForDetails($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $result = $this->model_my_account->account_details($parsed);

                if ($result['status_code'] == "ALLOK2") {
                    echo prepare_response(
                        "Success",
                        $status::AccountDetails['status_code'],
                        $status::AccountDetails['message'],
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
                    $is_valid_param['status_code'],
                    $is_valid_param['message'],
                    time(),
                    (object)array()
                );
            }
        }
    }
}

?>
