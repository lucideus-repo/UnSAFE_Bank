<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class SignUpModuleHandler extends CI_Model
{
    const SIGNUP_BENEFS = 4;
    public function validateParamsForExist($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // mobile
        if (isset($data['data']['mobile'])) {
            if (!preg_match("/^[0-9]{10}$/", $data['data']['mobile'])) {
                return $status::MobileInvalidOrNotSet;
            } else ;
        } else return $status::RequestParameterNotSet;
        // *****************************************************
        // email
        if (isset($data['data']['email']))
            if ((strlen($data['data']['email']) > 50) or
                (!preg_match("/^[A-Za-z0-9\.\_]+@[a-zA-Z_]+?\.[\.a-zA-Z]{2,10}$/", $data['data']['email'])))
                return $status::EmailInvalidOrNotSet;
            else ;
        else return $status::EmailInvalidOrNotSet;
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function validateSignUpAPIParameter($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // firstname
        if (isset($data['firstname']))
            if (!preg_match("/^[A-Za-z]{3,20}$/", $data['firstname']))
                return $status::FnameInvalidOrNotSet;
            else ;
        else return $status::FnameInvalidOrNotSet;
        // *****************************************************
        // lastname
        if (isset($data['lastname']))
            if (!preg_match("/^[A-Za-z]{3,20}$/", $data['lastname']))
                return $status::LnameInvalidOrNotSet;
            else ;
        else return $status::LnameInvalidOrNotSet;
        // *****************************************************
        // gndr
        if (isset($data['gndr'])) {
            if (!in_array($data['gndr'], array("1", "2", "3")))
                return $status::GndrInvalidOrNotSet;
            else ;
        } else return $status::GndrInvalidOrNotSet;
        // *****************************************************
        // mobile
        if (isset($data['mobile']))
            if (!preg_match("/^[0-9]{10}$/", $data['mobile']))
                return $status::MobileInvalidOrNotSet;
            else ;
        else return $status::MobileInvalidOrNotSet;
        // *****************************************************
        // email
        if (isset($data['email']))
            if ((strlen($data['email']) > 50) or
                (!preg_match("/^[A-Za-z0-9\.\_]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/", $data['email'])))
                return $status::EmailInvalidOrNotSet;
            else ;
        else return $status::EmailInvalidOrNotSet;
        // *****************************************************
        // passwd
        if (isset($data['passwd']))
          if (!preg_match("/^[A-Za-z0-9_@#\$]{1,20}$/", $data['passwd']))
          /* if (!preg_match("/^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$/", $data['passwd'])) */
                return $status::PasswdInvalidOrNotSet;
            else ;
        else return $status::PasswdInvalidOrNotSet;
        // *****************************************************
        // countryId
        if (isset($data['countryId'])) {
            if (!in_array($data['countryId'], array("IND", "AUS", "CAN", "USA", "UK")))
                return $status::CntryInvalidOrNotSet;
            else ;
        } else return $status::CntryInvalidOrNotSet;
        // ****************************************************
        // address
        if (isset($data['address']))
            if (!preg_match("/^[A-Za-z\-,0-9 ]{3,50}/", $data['address']))
                return $status::AddressInvalidOrNotSet;
            else ;
        else $status::AddressInvalidOrNotSet;
        // ****************************************************
        // dob
        if (isset($data['dob']))
            if (!preg_match(
                "/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/",
                $data['dob']))
                return $status::DobInvalidOrNotSet;
            else ;
        else return $status::DobInvalidOrNotSet;
        // ****************************************************
        // mobile number exists
        if ($this->mobile_exists($data['mobile']))
            return $status::MobileAlreadyExists;
        // ****************************************************
        // email exists
        if ($this->email_exists($data['email']))
            return $status::EmailAlreadyExists;
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function mobile_or_email_exists($data)
    {
        $status = new status_codes();
        if ($this->mobile_exists($data['data']['mobile']) or
            $this->email_exists($data['data']['email']) )
            return ($status::MobileOrEmailAlreadyExists + array("result" => "false"));
        return array(
            "status_code" => "ALLOK2",
            "message" => "Everything OK",
            "result" => "true"
        );
    }

    private function mobile_exists($mobile)
    {
        if (isset($this->db->query(
                "SELECT id_pk FROM user_details WHERE mobile_no = ?",
                array($mobile))->row_array()['id_pk']))
            return true;
        return false;
    }

    private function email_exists($email)
    {
        if (isset($this->db->query(
                "SELECT id_pk FROM user_details WHERE email = ?",
                array($email))->row_array()['id_pk']))
            return true;
        return false;
    }

    private function generateNew($name, $table, $prefix, $len)
    {
        $all_chars = "01234567890";
        do {
            $tmp = "";
            for ($i = 0; $i < $len; $i++)
                $tmp = $tmp . "0";
            for ($i = 0; $i < $len; $i++)
                $tmp[$i] = $all_chars[random_int(0, strlen($all_chars) - 1)];
            $rand = $prefix . $tmp;
        } while ($this->db->query(
            "SELECT id_pk FROM " . $table . " WHERE " . $name . " = ?",
            array($rand))->row_array()['id_pk'] != NULL);
        return $rand;
    }

    public function signup_user($data)
    {
        // ************************************************************
        // custid
        $custid = $this->generateNew("cust_id", "user", "BNK", 5);
        // ************************************************************
        // aadhaar
        $aadhaar = $this->generateNew("aadhar_id", "user_details", "", 12);
        // ************************************************************
        // aadhaar
        $panCard = $this->generateNew("pan_card_id", "user_details", "", 10);
        // ************************************************************
        // walletId
        $walletId = $this->generateNew("wallet_id", "user_details", "", 10);
        // ************************************************************
        // acctNo
        $acctNo = $this->generateNew("account_no", "account_details", "", 12);
        // ************************************************************
        // acctBalance - between 1L and 10L
        $acctBalance = random_int(10000000, 100000000)/100;
        // ************************************************************
        // incomTaxNo
        $incomTaxNo = $this->generateNew("income_tax_number", "account_details", "", 10);
        // ************************************************************
        // bankCode
        $bankid = random_int(1,
            $this->db->query(
                "SELECT COUNT(*) as cnt FROM bank_master"
            )->row_array()['cnt']);
        $bankCode = $this->db->query(
            "SELECT bank_code FROM bank_master WHERE id_pk = ?",
            array($bankid)
        )->row_array()['bank_code'];
        // ************************************************************
        // currencyTicker
        $currencyTicker = $this->db->query(
            "SELECT currency_ticker FROM country_master WHERE country_id = ?",
            array($data['data']['countryId'])
        )->row_array()['currency_ticker'];
        // ************************************************************
        // ******************* ALL DONE *******************************
        // count number of existing accounts
        $benef_total = $this->db->query(
            "SELECT COUNT(*) AS total FROM account_details"
        )->row_array()['total'];
        if ($benef_total > $this::SIGNUP_BENEFS) $benef_total = $this::SIGNUP_BENEFS;
        // assigned beneficiaries
        $benefs = $this->db->query(
        "SELECT
            a.account_no as acc,
            b.bank_code as ifsc
        FROM
            account_details a
        LEFT JOIN bank_master b ON
            a.bank_master_id_fk = b.id_pk"
        )->result_array();
        shuffle($benefs);
        array_splice($benefs, $benef_total);
        // user table
        $stmt = $this->db->query(
            "INSERT INTO user (
                password,
                account_type,
                is_active,
                user_role,
                device_os,
                host,
                cust_id,
                device_id
            ) VALUES (?,?,?,?,?,?,?,?)",
            array(
                md5($data['data']['passwd']),
                '0',
                '1',
                "USER",
                $data['device']['os'],
                $data['device']['host'],
                $custid,
                $data['device']['deviceid']
            )
        );
        // user_details table
        $user_fk = $this->db->query(
            "SELECT id_pk FROM user WHERE cust_id = ?",
            array($custid)
        )->row_array() ['id_pk'];
        $stmt = $this->db->query(
            "INSERT INTO user_details (
                user_id_fk,
                fname,
                lname,
                address,
                dob,
                mobile_no,
                email,
                aadhar_id,
                pan_card_id,
                wallet_id,
                gender,
                country_id
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
            array(
                $user_fk,
                $data['data']['firstname'],
                $data['data']['lastname'],
                $data['data']['address'],
                $data['data']['dob'],
                $data['data']['mobile'],
                $data['data']['email'],
                $aadhaar,
                $panCard,
                $walletId,
                $data['data']['gndr'],
                $data['data']['countryId']
            )
        );
        // account_details table
        $user_details_fk = $this->db->query(
            "SELECT id_pk FROM user_details WHERE aadhar_id = ?",
            array($aadhaar)
        )->row_array() ['id_pk'];
        $stmt = $this->db->query(
            "INSERT INTO account_details (
                user_id_fk,
                user_details_id_fk,
                bank_master_id_fk,
                account_no,
                account_balance,
                income_tax_number,
                account_opening_date,
                currency_ticker,
                updated_at
            ) VALUES (?,?,?,?,?,?,?,?,?)",
            array(
                $user_fk,
                $user_details_fk,
                $bankid,
                $acctNo,
                $acctBalance,
                $incomTaxNo,
                date("Y-m-d"),
                $currencyTicker,
                time()
            )
        );
        // provide beneficiaries
        $sql = "INSERT INTO beneficiary_details (
            user_id_fk,
            beneficiary_alias,
            beneficiary_account_no,
            bank_code
        ) VALUES (?,?,?,?)";
        while($benef_total > 0) {
            $stmt = $this->db->query($sql, array(
                $user_fk,
                $this->db->query(
                    "SELECT
                        d.fname
                    FROM
                        user_details as d
                        RIGHT JOIN account_details as a
                            ON a.user_details_id_fk=d.id_pk
                    WHERE
                        a.account_no=?
                    ", array($benefs[$benef_total-1]['acc'])
                )->row_array()["fname"],
                $benefs[$benef_total-1]['acc'],
                $benefs[$benef_total-1]['ifsc']
            ));
            $benef_total--;
        }
        $this->load->helper('global_methods');
        return array(
            "userId" => $custid,
            "refNo"  => generateRandNoWithLength(15)
        );
    }
}

