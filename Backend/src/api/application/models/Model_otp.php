<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Model_Otp extends CI_Model
{

    // OTP Expiry is set to 5 mins i.e. 300s
    const OTP_EXPIRY = 300;

    private function generate_new_otp()
    {
        do {
            $all_chars = "1234567890";
            $otp = "123456";
            for ($i = 0; $i < 20; $i++) {
                $otp[$i] = $all_chars[random_int(0, strlen($all_chars) - 1)];
            }
        } while (!$this->is_existing_otp($otp));
        return $otp;
    }

    private function is_existing_otp($otp)
    {
        $result = $this->db->query(
            "SELECT id_pk
            FROM otp_master
            WHERE otp_no = ?",
            array($otp))->row_array();
        if (isset($result['id_pk'])) {
            return false;
        }
        return true;
    }

    private function generate_new_otpref()
    {
        do {
            $all_chars = "1234567890";
            $otp_ref = "123456789012";
            for ($i = 0; $i < 20; $i++) {
                $otp_ref[$i] = $all_chars[random_int(0, strlen($all_chars) - 1)];
            }
        } while (!$this->is_existing_otpref($otp_ref));
        return $otp_ref;
    }

    private function is_existing_otpref($otp_ref)
    {
        $result = $this->db->query(
            "SELECT id_pk
            FROM otp_master
            WHERE otp_ref = ?",
            array($otp_ref)
        )->row_array();
        if (isset($result['id_pk'])) {
            return false;
        }
        return true;
    }

    private function has_pending_otp($owner)
    {
        $result = $this->db->query(
            "SELECT id_pk
            FROM otp_master
            WHERE user_details_id_fk = ?",
            array($owner)
        )->row_array();
        if (isset($result['id_pk'])) {
            return true;
        }
        return false;
    }

    public function validateParamsForGet($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // otp_type
        // 1: Add Beneficiary
        // 2: Delete Beneficiary
        // 3: Fund Transfer
        $otpTypes = array("1", "2", "3");
        if (isset($data['data']['otp_type'])) {
            if (!in_array($data['data']['otp_type'], $otpTypes)) {
                return $status::InvalidOtpType;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function validateParamsForForgot($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // userid
        if (isset($data['data']['userid'])) {
            if (!preg_match("/^[A-Za-z0-9]{1,15}$/", $data['data']['userid'])) {
                return $status::InvalidUserIdFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // otp_type
        // 4: Forgot Password
        if (isset($data['data']['otp_type'])) {
            if ($data['data']['otp_type'] != "4") {
                return $status::InvalidOtpType;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }


    public function validateParamsForVerify($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // otp
        if (isset($data['data']['otp'])) {
            if (!preg_match("/^[0-9]{6}$/", $data['data']['otp'])) {
                return $status::InvalidOtpFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function validateParamsForVerify1($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // otp
        if (isset($data['data']['otp'])) {
            if (!preg_match("/^[0-9]{6}$/", $data['data']['otp'])) {
                return $status::InvalidOtpFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // userid
        if (isset($data['data']['userid'])) {
            if (!preg_match("/^[A-Za-z0-9]{1,10}$/", $data['data']['userid'])) {
                return $status::IncorrectUseridFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function generate($owner, $data)
    {
        $new_otp = $this->generate_new_otp();
        $sixDigitOTP = substr($new_otp,0,6);
        $new_otp_ref = $this->generate_new_otpref();
        $owner_detailid = $this->db->query(
            "SELECT
                user_details_id_fk as detailid
            FROM
                account_details
            WHERE
                id_pk = ?", array($owner)
        )->row_array()["detailid"];
        if (!$this->has_pending_otp($owner_detailid)) {
            $sql = "INSERT INTO otp_master (
                otp_no,
                otp_timestamp,
                otp_purpose,
                otp_ref,
                user_details_id_fk,
                remaining_attempts,
                verified
            ) VALUES (?, ?, ?, ?, ?, 5, 0)";
//This if else condition has been added intentionally for OTP brute force on fund transfer
        } else if($data['data']['otp_type']==3){
            $sql = "UPDATE otp_master
                SET
                    otp_no = ?,
                    otp_timestamp = ?,
                    otp_purpose = ?,
                    otp_ref = ?,
                    remaining_attempts = -9,
                    verified = 0
                WHERE
                    user_details_id_fk = ?";
        }else {
            $sql = "UPDATE otp_master
                SET
                    otp_no = ?,
                    otp_timestamp = ?,
                    otp_purpose = ?,
                    otp_ref = ?,
                    remaining_attempts = 5,
                    verified = 0
                WHERE
                    user_details_id_fk = ?";
        }
        $this->db->query($sql,
            array(
                $sixDigitOTP,
                time(),
                $data["data"]["otp_type"],
                $new_otp_ref,
                $owner_detailid
            )
        );
        $otp = array("response" => base64_encode(openssl_encrypt(
            $sixDigitOTP,
            'aes-256-cbc',
            "9bbc0d79e686e847bc305c9bd4cc2ea6",
            $options=OPENSSL_RAW_DATA,
            "0123456789abcdef"
        )));
        if ($data["data"]["otp_type"] == 2)
            $otp += array("checksum" => sha1($sixDigitOTP));
        return $otp;
    }

    public function check_otp($owner, $data)
    {
        $owner_detailid = $this->db->query(
            "SELECT
                user_details_id_fk as detailid
            FROM
                account_details
            WHERE
                id_pk = ?", array($owner)
        )->row_array()["detailid"];
        // get the otp
        $result = $this->db->query(
            "SELECT
                otp_no,
                otp_ref,
                otp_purpose,
                otp_timestamp,
                remaining_attempts,
                verified
            FROM otp_master
            WHERE user_details_id_fk = ?",
            array($owner_detailid)
        )->row_array();
        // No OTP was assigned
        if (!isset($result['otp_no'])) {
            return array("attempts" => -2);
        }
        // OTP already verified
        if ($result['verified'] == 1) {
            return array("attempts" => -2);
        }
        // OTP expired
        if (time()-$result['otp_timestamp'] > $this::OTP_EXPIRY) {
            return array("attempts" => -2);
        }
        $generated = $result['otp_no'];
        $input = $data['data']['otp'];
        if ($generated == $input) {
            $complete = $this->db->query(
                "UPDATE otp_master
                SET verified = 1
                WHERE user_details_id_fk = ?",
                array($owner_detailid));
            return array(
                "attempts" => -1,
                "response" => $result['otp_ref']
            );
        } else {
            $left = $result['remaining_attempts'] - 1;
            if ($left == 0) {
                $stmt = $this->db->query(
                    "DELETE FROM otp_master
                    WHERE user_details_id_fk = ?",
                    array($owner_detailid)
                );
            } else {
                $stmt = $this->db->query(
                    "UPDATE otp_master
                    SET remaining_attempts = ?
                    WHERE user_details_id_fk = ?",
                    array($left, $owner_detailid)
                );
            }

            return array(
                "attempts" => $left,
                "otp_type" => $result['otp_purpose']
            );
        }
    }
}
