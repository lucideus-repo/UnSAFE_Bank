<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Beneficiary extends CI_Controller
{

    public function pay()
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
            $this->load->model('Model_beneficiary');
            $is_valid_param = $this->Model_beneficiary->validate_pay($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $pay_result = $this->Model_beneficiary->pay_ben($parsed);
                if ($pay_result['status_code'] != "ALLOK2") {
                    echo prepare_response(
                        "Failed",
                        $pay_result['status_code'],
                        $pay_result['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    echo prepare_response(
                        "Success",
                        $status::PaymentSuccess['status_code'],
                        $status::PaymentSuccess['message'],
                        time(),
                        $pay_result['data']
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

    public function add()
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
            $this->load->model('Model_beneficiary');
            $is_valid_param = $this->Model_beneficiary->validate_add($parsed);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $add_result = $this->Model_beneficiary->add_ben($parsed);
                if ($add_result['status_code'] != "ALLOK2") {
                    echo prepare_response(
                        "Failed",
                        $add_result['status_code'],
                        $add_result['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    echo prepare_response(
                        "Success",
                        $status::BeneficiaryAddSuccess['status_code'],
                        $status::BeneficiaryAddSuccess['message'],
                        time(),
                        (object) array("referenceNo" => $add_result['data'])
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
            $this->load->model('Model_beneficiary');
            $get_result = $this->Model_beneficiary->get_ben($parsed);
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
                    $status::BeneficiaryListSuccess['status_code'],
                    $status::BeneficiaryListSuccess['message'],
                    time(),
                    (object) array("result" => $get_result['data'])
                );
            }
        }
    }

    public function list()
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
            $this->load->model('Model_beneficiary');
            $list_result = $this->Model_beneficiary->list_ben($parsed);
            if ($list_result['status_code'] != "ALLOK2") {
                echo prepare_response(
                    "Failed",
                    $list_result['status_code'],
                    $list_result['message'],
                    time(),
                    (object)array()
                );
            } else {
                echo prepare_response(
                    "Success",
                    $status::BeneficiaryListSuccess['status_code'],
                    $status::BeneficiaryListSuccess['message'],
                    time(),
                    (object) array("alias" => $list_result['data'])
                );
            }
        }
    }

    public function delete()
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
            $this->load->model('Model_beneficiary');
            $is_valid_param = $this->Model_beneficiary->validate_delete($parsed['data']);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $fetch_result = $this->Model_beneficiary->delete_ben($parsed);
                if ($fetch_result['status_code'] != "ALLOK2") {
                    echo prepare_response(
                        "Failed",
                        $fetch_result['status_code'],
                        $fetch_result['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    echo prepare_response(
                        "Success",
                        $status::BeneficiaryDeleteSuccess['status_code'],
                        $status::BeneficiaryDeleteSuccess['message'],
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

    public function fetch()
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
            $this->load->model('Model_beneficiary');
            $is_valid_param = $this->Model_beneficiary->validate_fetch($parsed['data']);
            if ($is_valid_param['status_code'] == "ALLOK1") {
                $fetch_result = $this->Model_beneficiary->fetch_ben($parsed);
                if ($fetch_result['status_code'] != "ALLOK2") {
                    echo prepare_response(
                        "Failed",
                        $fetch_result['status_code'],
                        $fetch_result['message'],
                        time(),
                        (object)array()
                    );
                } else {
                    if ($fetch_result['data']['alias'] === null) {
                        echo prepare_response(
                            "Failed",
                            $status::BeneficiaryNotExist['status_code'],
                            $parsed['data']['alias']." does not exist",
                            time(),
                            $fetch_result['data']
                        );
                    }
                    else {
                        echo prepare_response(
                            "Success",
                            $status::BeneficiaryFetchSuccess['status_code'],
                            $status::BeneficiaryFetchSuccess['message'],
                            time(),
                            $fetch_result['data']
                        );
                    }
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
