<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Model_edit_account extends CI_Model
{


    public function urlExists($url = NULL)
    {
        if ($url == NULL) return false;
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_TIMEOUT, 3);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        $data = curl_exec($ch);
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if ($httpcode >= 200 && $httpcode < 310) {
            return true;
        } else {
            return false;
        }
    }

    public function validateEditUserApiParameter($account_id, $data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // firstname
        if (isset($data['firstName']))
            if (!preg_match("/^[A-Za-z]{3,20}$/", $data['firstName']) || !strlen($data['firstName']))
                return $status::FnameInvalid;
            else;
        else return $status::FnameInvalid;
        // *****************************************************
        // lastname
        if (isset($data['lastName']))
            if (!preg_match("/^[A-Za-z]{3,20}$/", $data['lastName']) || !strlen($data['lastName']))
                return $status::LnameInvalid;
            else;
        else return $status::LnameInvalid;
        // *****************************************************
        // email
        if (isset($data['email']))
            if ((strlen($data['email']) > 50) or
                (!preg_match("/^[A-Za-z0-9\.\_]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/", $data['email']) || strlen($data['email']) < 2)
            )
                return $status::EmailInvalid;
            else;
        else return $status::EmailInvalid;

        // mobile
        if (isset($data['mobile']))
            if (!preg_match("/^[0-9]{10}$/", $data['mobile']) || !strlen($data['mobile']))
                return $status::MobileInvalid;
            else;
        else return $status::MobileInvalid;
        // *****************************************************
        // address
        if (!isset($data['address']))
            return $status::AddressInvalid;
        //avatar
        if (!isset($data['avatar']))
            return $status::AvatarInvalid;

        if (!$this->urlExists($data['avatar']))
            return $status::AvatarInvalid;
        // ****************************************************
        // mobile number exists
        if ($this->mobile_exists($account_id, $data['mobile']))
            return $status::EditMobileAlreadyExists;
        // ****************************************************
        // email exists
        if ($this->email_exists($account_id, $data['email']))
            return $status::EditEmailAlreadyExists;
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    private function mobile_exists($account_id, $mobile)
    {
        $result = $this->db->query(
            "SELECT id_pk FROM user_details WHERE mobile_no = ?",
            array($mobile)
        )->row_array()['id_pk'];
        $isSame = ($result == $account_id);

        if ($isSame)
            return false;
        if (isset($this->db->query(
            "SELECT id_pk FROM user_details WHERE mobile_no = ?",
            array($mobile)
        )->row_array()['id_pk']))
            return true;
        return false;
    }

    private function email_exists($account_id, $email)
    {
        $result = $this->db->query(
            "SELECT id_pk FROM user_details WHERE email = ?",
            array($email)
        )->row_array()['id_pk'];
        $isSame = ($result == $account_id);

        if ($isSame)
            return false;
        if (isset($this->db->query(
            "SELECT id_pk FROM user_details WHERE email = ?",
            array($email)
        )->row_array()['id_pk']))
            return true;
        return false;
    }

    public function editUserData($accountId, $data)
    {
        $this->db->query("UPDATE user_details SET fname = ?,lname = ?,address = ? , mobile_no = ?, email = ?, avatar = ? WHERE user_id_fk = ?", array($data["firstName"], $data["lastName"], $data["address"], $data["mobile"], $data["email"], $data["avatar"], $accountId));
    }
}
