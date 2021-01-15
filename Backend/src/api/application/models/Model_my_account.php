<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Model_My_Account extends CI_Model
{

    public function validateParamsForDetails($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // userid
        if (isset($data['data']['userid'])) {
            if (!preg_match("/^[A-Za-z0-9]{3,20}$/", $data['data']['userid'])) {
                return $status::IncorrectUseridFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function account_details($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        if (is_valid_session($data['token']) == null) {
            return $status::InvalidSession;
        }
        // validate accountid with userid to prevent IDOR
        $userid = $data['data']['userid'];
        $accountid = $this->db->query(
            "SELECT
                a.id_pk
            FROM
                user as u
            RIGHT JOIN account_details as a
                ON u.id_pk = a.user_id_fk
            WHERE
                cust_id = ?",
            array($userid)
        )->row_array();
        if ($accountid == null) {
            return $status::UserIdDoesNotExist;
        } else {
            return array(
                "status_code" => "ALLOK2",
                "message" => "Success",
                "data" => $this->db->query(
                    "SELECT
                        a.account_no as accountNumber,
                        ROUND(a.account_balance, 2) as accountBalance,
                        a.income_tax_number as incomeTaxNumber,
                        a.account_opening_date as openDate,
                        a.currency_ticker as currency,
                        d.fname as fname,
                        d.lname as lname,
                        d.avatar as avatar,
                        d.address as address,
                        d.dob as dob,
                        d.mobile_no as mobileNo,
                        d.email as email,
                        d.aadhar_id as aadharId,
                        d.pan_card_id as panCardId,
                        d.wallet_id as walletId,
                        d.gender as gender,
                        d.country_id as countryId,
                        u.cust_id as userId
                    FROM
                        account_details AS a
                    LEFT JOIN user_details AS d
                        ON a.user_details_id_fk = d.id_pk
                    LEFT JOIN user AS u
                        ON a.user_id_fk = u.id_pk
                    WHERE
                        a.id_pk = ?",
                    array($accountid)
                )->row_array()
            );
        }
    }
}
