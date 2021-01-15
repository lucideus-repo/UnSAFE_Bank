<?php
defined('BASEPATH') or exit('No direct script access allowed');

class LoginModuleHandler extends CI_Model
{
    public function new_token($details)
    {
        $details['exp'] = time() + (60 * 60 * 24 * 7);
        $this->load->helper('jwt_helper');
        $JWT = new JWT();

        do {
            $key = "unsafebank";
            $token = $JWT::encode($details, $key);
        } while (!$this->is_existing_token($token));
        return $token;
    }

    public function is_existing_token($token)
    {
        $stmt = $this->db->query(
            "SELECT cust_id
            FROM session_master
            WHERE session_id = ?",
            array($token)
        )->row_array();
        if (isset($stmt['cust_id'])) {
            return false;
        }
        return true;
    }

    public function validateLoginAPIParameter($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // userid
        if (isset($data['data']['userid'])) {
            if (!preg_match("/^[A-Za-z0-9]{1,10}$/", $data['data']['userid'])) {
                return $status::IncorrectUseridFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // passwd
        if (isset($data['data']['passwd'])) {
            if (!preg_match("/^[A-Za-z0-9!@#\$%\^&*()<>?.]{1,20}$/", $data['data']['passwd'])) {
                return $status::IncorrectPasswordFormat;
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

    public function login_user($data)
    {
        $status = new status_codes();
        $userid = $data['data']['userid'];
        $passwd = md5($data['data']['passwd']);
        $stmt = $this->db->query(
            "SELECT cust_id
            FROM user
            WHERE cust_id = ? AND password = ?",
            array($userid, $passwd)
        );
        // print_r($stmt);
        // die;
        $res = $stmt->row_array();
        if (isset($res['cust_id'])) {
            // existing session                
            $custId = $res['cust_id'];
            $stmt = $this->db->query(
                "SELECT session_id, last_access
                FROM session_master
                WHERE cust_id = ?",
                array($custId)
            )->row_array();

            if (isset($stmt['session_id'])) {
                // last_access was less than 150 s
                // updated to 60s @18-Mar-2019
                // updated to 300s @13-May-2020
                $time_diff = time() - $stmt['last_access'];
                if ($time_diff < 300) {
                    return $status::CoolDownPeriod;
                }
                $sql = "UPDATE session_master
                    SET session_id = ? , last_access = ?
                    WHERE cust_id = ?";
            } else {
                $sql = "INSERT INTO session_master (
                    session_id,
                    last_access,
                    cust_id
                ) VALUES (?, ?, ?)";
            }

            // include account details
            $accountid = $this->db->query(
                "SELECT a.id_pk as id
                FROM user as u
                RIGHT JOIN account_details as a
                    ON u.id_pk = a.user_id_fk
                WHERE cust_id = ?",
                array($userid)
            )->row_array()['id'];
            $details = $this->db->query(
                "SELECT
                    a.account_no as acctNo,
                    ROUND(a.account_balance, 2) as acctBalance,
                    a.income_tax_number as incomeTaxNumber,
                    a.account_opening_date as acctOpeningDate,
                    a.currency_ticker as currency,
                    d.fname as fname,
                    d.lname as lname,
                    d.address as address,
                    d.dob as dob,
                    d.mobile_no as mobileNo,
                    d.email as email,
                    d.aadhar_id as aadharId,
                    d.pan_card_id as panCardId,
                    d.wallet_id as walletId,
                    d.gender as gender,
                    d.country_id as countryId
                FROM
                    account_details AS a
                LEFT JOIN user_details AS d
                ON
                    a.user_details_id_fk = d.id_pk
                WHERE
                    a.id_pk = ?",
                array($accountid)
            )->row_array();
            $token = $this->new_token($details);
            $stmt = $this->db->query($sql, array($token, time(), $custId));
            return array(
                'status_code' => 'ALLOK2',
                'data' => array("token" => $token) +
                    $details +
                    array("userid" => $userid)
            );
        } else {
            return $status::LoginError;
        }
    }
}
