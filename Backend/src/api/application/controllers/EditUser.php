<?php
defined('BASEPATH') or exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class EditUser extends CI_Controller
{

    public function editUserDetails()
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
                    $this->load->model('Model_edit_account');
                    $is_valid_param = $this->Model_edit_account->validateEditUserApiParameter($account_id, $parsed["data"]);
                    if ($is_valid_param['status_code'] == "ALLOK1") {
                        $this->Model_edit_account->editUserData($account_id, $parsed["data"]);
                        echo prepare_response(
                            "Success",
                            $status::EditSuccess['status_code'],
                            $status::EditSuccess['message'],
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
}
