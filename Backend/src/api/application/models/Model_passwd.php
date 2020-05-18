<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Model_Passwd extends CI_Model
{
    public function get_accountid($data)
    {
        $userid = $data['data']['userid'];
        $result = $this->db->query(
            "SELECT d.id_pk as accountid
            FROM account_details as d
            LEFT JOIN user as u
                ON d.user_id_fk = u.id_pk
            WHERE u.cust_id = ?",
            array($userid)
        )->row_array();
        if (isset($result['accountid'])) {
            return $result['accountid'];
        }
        return null;
    }

    public function validateParamsForChange($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // old_pass
        if (isset($data['old_pass'])) {
            if (!preg_match("/^[A-Za-z0-9_@#\$]{1,20}$/", $data['old_pass'])) {
                return $status::IncorrectOldPasswordFormat;
            } else { 
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // new_pass
        if (isset($data['new_pass'])) {
            if (!preg_match("/^[A-Za-z0-9_@#\$]{1,20}$/", $data['new_pass'])) {
                return $status::IncorrectNewPasswordFormat;
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

    public function validateParamsForReset($data)
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
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // otp_response
        if (isset($data['data']['otp_response'])) {
            if (!preg_match("/^[0-9]{15}$/", $data['data']['otp_response'])) {
                return $status::IncorrectOtpReferenceFormat;
            } else { 
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // new_pass
        if (isset($data['data']['new_pass'])) {
            if (!preg_match("/^[A-Za-z0-9!@#\$%\^&*()<>?.]{1,20}$/", $data['data']['new_pass'])) {
                return $status::IncorrectPasswordFormat;
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

    public function reset_user_passwd($accountid, $data)
    {
        $otpref = $data['data']['otp_response'];
        $newpass = $data['data']['new_pass'];
        $this->load->helper('request_response');
        $status = new status_codes();
        $detailid = $this->db->query(
            "SELECT
                user_details_id_fk as detailid
            FROM
                account_details
            WHERE
                id_pk = ?", array($accountid)
        )->row_array()["detailid"];

        // check for otp reference
        $result = $this->db->query(
            "SELECT
                user_details_id_fk as id,
                otp_purpose as purpose,
                verified as verified
            FROM otp_master
            WHERE otp_ref = ?",
            array($otpref)
        )->row_array();
        // delete otp reference
        $stmt = $this->db->query(
            "DELETE FROM otp_master WHERE otp_ref = ?",
            array($otpref)
        );
        if (isset($result['id'])) {
            // check purpose
            if ($result['purpose'] != '4') {
                return $status::InvalidOtpPurpose;
            }
            // check if verified
            if ($result['verified'] != '1') {
                return $status::InvalidOtpPurpose;
            }
            // find user.id_pk
            $stmt = $this->db->query(
                "SELECT u.id_pk as userid
                FROM user as u
                LEFT JOIN user_details as d
                    ON u.id_pk = d.user_id_fk
                WHERE d.id_pk = ?",
                array($detailid)
            );
            // d.id_pk = ?", array($result['id']));
            // replace the line 128 with 131 to patch account takeover
            $result = $stmt->row_array();
            if (!isset($result['userid'])) {
                return $status::DBSyncError;
            } else {
                $userid = $result['userid'];
                $stmt = $this->db->query(
                    "UPDATE user as u SET password = ? WHERE u.id_pk = ?",
                    array(md5($newpass), $userid)
                );
                return array(
                    "status_code" => "ALLOK2",
                    "message" => "Success"
                );
            }
        } else {
            return $status::InvalidOtpResponse;
        }
    }

    public function change_passwd($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();

        $oldpass = md5($data['data']['old_pass']);
        $newpass = md5($data['data']['new_pass']);

        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            if ($oldpass == $newpass) {
                return $status::NewPasswdOldPasswd;
            }
            $stmt = $this->db->query(
                "SELECT user_id_fk FROM account_details WHERE id_pk = ?",
                array($accountid)
            )->row_array();
            if (!isset($stmt['user_id_fk'])) {
                return $status::DBSyncError;
            } else {
                $userid = $stmt['user_id_fk'];
                /* For Insecure Change Password functionality
                if (!isset($this->db->query(
                    "SELECT cust_id FROM user WHERE id_pk = ? and password =?",
                    array($userid, $oldpass)
                )->row_array()['cust_id'])) {
                    return $status::OldPassIncorrect;
                }
                */
                $stmt = $this->db->query(
                    "UPDATE user SET password = ? WHERE id_pk = ?",
                    array($newpass, $userid)
                );
                return array(
                    "status_code" => "ALLOK2",
                    "message" => "Success"
                );
            }
        }
    }
}

?>
