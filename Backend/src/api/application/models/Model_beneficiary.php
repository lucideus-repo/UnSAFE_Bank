<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Model_Beneficiary extends CI_Model
{
    // introduce otp reference expiry to be 10 mins
    const OTP_REF_EXPIRY = 600;

    public function validate_add($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::NoToken;
        }
        // *****************************************************
        // ifsc_code
        if (isset($data['data']['ifsc_code'])) {
            if (!preg_match("/^[A-Za-z0-9]{9}$/", $data['data']['ifsc_code'])) {
                return $status::IncorrectIfscFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // account_number
        if (isset($data['data']['account_number'])) {
            if (!preg_match("/^[A-Za-z0-9]{12}$/", $data['data']['account_number'])) {
                return $status::IncorrectAcNoFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // alias
        if (isset($data['data']['alias'])) {
            if (!preg_match("/^[A-Za-z0-9\ ]{3,50}$/", $data['data']['alias'])) {
                return $status::IncorrectAliasFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        /* removed on 21 Jul 2019 by @Vibhav
        // email
        if (isset($data['data']['email'])) {
            if ((
                !preg_match("/^[A-Za-z0-9\.\_]+\@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/",
                    $data['data']['email'])
                ) or
                (strlen($data['data']['email']) > 50)
            ) {
                return $status::IncorrectEmailFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        */
        // *****************************************************
        // otp_response
        if (isset($data['data']['otp_response'])) {
            if (!preg_match(
                "/^[A-Za-z0-9]{15}$/",
                $data['data']['otp_response']
            )) {
                return $status::IncorrectOtpReferenceFormat;
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

    public function validate_pay($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::NoToken;
        }
        // *****************************************************
        // amount
        if (isset($data['data']['amount'])) {
            $amt = $data['data']['amount'];
            if ((strlen($amt) > 10)
                or !(is_double(floatval($amt)) or is_int(intval($amt)))
            ) {
                return $status::IncorrectAmountFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // alias
        if (isset($data['data']['alias'])) {
            if (!preg_match("/^[A-Za-z0-9]{3,50}$/", $data['data']['alias'])) {
                return $status::IncorrectAliasFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // remarks
        if (isset($data['data']['remarks'])) {
            if (!preg_match("/^[A-Za-z0-9\ ]{2,30}$/", $data['data']['remarks'])) {
                return $status::IncorrectRemarksFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // otp_response
        if (isset($data['data']['otp_response'])) {
            if (!preg_match("/^[A-Za-z0-9]{15}$/", $data['data']['otp_response'])) {
                return $status::IncorrectOtpReferenceFormat;
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

    public function validate_get_list($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::NoToken;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function add_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        $otpref = $data['data']['otp_response'];
        // check for session
        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            // check for otp reference
            $result = $this->db->query(
                "SELECT
                    account.user_details_id_fk as detailid,
                    account.user_id_fk as userid,
                    account.id_pk as accountid,
                    otp.otp_purpose as purpose,
                    otp.verified as verified,
                    otp.otp_timestamp as otptime
                FROM
                    otp_master as otp
                RIGHT JOIN account_details as account
                    ON otp.user_details_id_fk = account.user_details_id_fk
                WHERE
                    otp.otp_ref = ?",
                array($otpref)
            )->row_array();
            $stmt = $this->db->query(
                "DELETE FROM otp_master
                WHERE otp_ref = ?",
                array($otpref)
            );
            if (isset($result['accountid'])) {
                // check purpose
                if ($result['purpose'] != '1') {
                    return $status::InvalidOtpPurpose;
                }
                // check if verified
                if ($result['verified'] != '1') {
                    return $status::InvalidOtpResponse;
                }
                // match otp_ref_id with session
                if ($accountid == $result['accountid']) {
                    // check for otp response validity
                    if (time() - $result['otptime'] > $this::OTP_REF_EXPIRY) {
                        return $status::ExpiredOtpResponse;
                    }
                    // check for account number
                    $userid = $result['userid'];
                    $detailid = $result['detailid'];
                    $result = $this->db->query(
                        "SELECT
                            account.id_pk
                        FROM
                            account_details as account
                            LEFT JOIN bank_master as bank
                                ON account.bank_master_id_fk = bank.id_pk
                        WHERE account.account_no = ? AND
                            bank.bank_code = ?",
                        array(
                            $data['data']['account_number'],
                            $data['data']['ifsc_code']
                        )
                    )->row_array();
                    if (isset($result['id_pk'])) {
                        // check for self account number
                        if ($accountid != $result['id_pk']) {
                            // check for existing beneficiary
                            // check for existing alias
                            $beneficiaries = $this->list_beneficiaries($userid);
                            $alias = strtoupper($data['data']['alias']);
                            foreach ($beneficiaries as $beneficiary) {
                                if (
                                    $beneficiary['account_number'] ==
                                    $data['data']['account_number']
                                ) {
                                    return $status::BeneficiaryAlreadyExist;
                                }
                                if (
                                    strtoupper($beneficiary['alias']) ==
                                    $alias
                                ) {
                                    return $status::AliasAlreadyExist;
                                }
                            }
                            // add beneficary
                            // beneficiary_email removed on 21 Jul 2019 by @Vibhav
                            $stmt = $this->db->query(
                                "INSERT INTO beneficiary_details (
                                    user_id_fk,
                                    beneficiary_alias, 
                                    beneficiary_account_no,
                                    bank_code
                                ) VALUES (?,?,?,?)",
                                array(
                                    $userid,
                                    $alias,
                                    $data['data']['account_number'],
                                    $data['data']['ifsc_code']
                                )
                            );
                            $all_chars = "1234567890";
                            $ref = "0000000000";
                            for ($i = 0; $i < strlen($ref); $i++) {
                                $ref[$i] = $all_chars[random_int(0, strlen($all_chars) - 1)];
                            }
                            return array(
                                "status_code" => "ALLOK2",
                                "message" => "Success",
                                "data" => $ref
                            );
                        } else {
                            return $status::BeneficiaryAccountNumberIsSelf;
                        }
                    } else {
                        return $status::BeneficiaryAccountNumberNotExist;
                    }
                } else {
                    return $status::OtpSessionMismatch;
                }
            } else {
                return $status::InvalidOtpResponse;
            }
        }
    }

    public function get_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        // check for session
        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            $stmt = $this->db->query(
                "SELECT user_id_fk
                FROM account_details
                WHERE id_pk = ?",
                array($accountid)
            );
            $result = $stmt->row_array();
            if (!isset($result['user_id_fk'])) {
                return $status::DBSyncError;
            } else {
                $result = $this->list_beneficiaries($result['user_id_fk']);
                $ret = array();
                foreach ($result as $i) {
                    array_push($ret, $i['alias'] . " - " . $i['account_number']);
                }
                return array(
                    "status_code" => "ALLOK2",
                    "message" => "Success",
                    "data" => $ret
                );
            }
        }
    }

    public function list_beneficiaries($userid)
    {
        $stmt = $this->db->query(
            "
            SELECT
                beneficiary_alias as alias,
                beneficiary_account_no as account_number
            FROM
                beneficiary_details
            WHERE
                user_id_fk = ?",
            array($userid)
        )->result_array();
        return $stmt;
    }

    public function list_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        // check for session
        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            $stmt = $this->db->query(
                "SELECT user_id_fk
                FROM account_details
                WHERE id_pk = ?",
                array($accountid)
            );
            $result = $stmt->row_array();
            if (!isset($result['user_id_fk'])) {
                return $status::DBSyncError;
            } else {
                $result = $this->list_beneficiaries($result['user_id_fk']);
                $ret = array();
                foreach ($result as $i) {
                    array_push($ret, $i['alias']);
                }
                return array(
                    "status_code" => "ALLOK2",
                    "message" => "Success",
                    "data" => $ret
                );
            }
        }
    }

    public function validate_fetch($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        /*
        // *****************************************************
        // alias
        if (isset($data['alias'])) {
            if (!preg_match("/^[A-Za-z0-9 ]{3,50}$/", $data['alias'])) {
                return $status::IncorrectAliasFormat;
            } else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        */
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function validate_delete($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // alias
        if (isset($data['alias'])) {
            if (!preg_match("/^[A-Za-z0-9]{3,50}$/", $data['alias'])) {
                return $status::IncorrectAliasFormat;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // otp_response
        if (isset($data['otp_response'])) {
            if (!preg_match("/^[A-Za-z0-9]{15}$/", $data['otp_response'])) {
                return $status::IncorrectOtpReferenceFormat;
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

    public function fetch_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        // check for session
        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            $stmt = $this->db->query(
                "SELECT user_id_fk
                FROM account_details
                WHERE id_pk = ?",
                array($accountid)
            );
            $result = $stmt->row_array();
            if (!isset($result['user_id_fk'])) {
                return $status::DBSyncError;
            } else {
                $ali = strtoupper($data['data']['alias']);
                /* beneficiary_email was removed. SELECT query updated
                 on 16-Feb-2020 by @Vibhav */
                $sql = "SELECT
                    beneficiary_alias,
                    beneficiary_account_no,
                    bank_code,
                    created_at
                FROM
                    beneficiary_details
                WHERE
                    beneficiary_alias = '$ali'
                    AND
                    user_id_fk = " . $result['user_id_fk'];
                $stmt = $this->db->query($sql);
                $error = $this->db->error();
                /*
                $stmt = $this->db->query(
                    "SELECT
                        beneficiary_alias,
                        beneficiary_email,
                        beneficiary_account_no,
                        bank_code,
                        created_at
                    FROM
                        beneficiary_details
                    WHERE
                        user_id_fk = ? AND beneficiary_alias = ?",
                    array(
                        $result['user_id_fk'],
                        strtoupper($data['data']['alias'])
                    )
                );
                */
                if ($error['code'] == 0) {
                    $result = $stmt->row_array();
                    /* beneficiary_email was removed. return array updated
             on 16-Feb-2020 by @Vibhav */
                    return array(
                        "status_code" => "ALLOK2",
                        "data" => array(
                            "alias" => $result['beneficiary_alias'],
                            "accountNumber" => $result['beneficiary_account_no'],
                            "ifscCode" => $result['bank_code'],
                            "creationDateTime" => $result['created_at']
                        )
                    );
                } else {
                    return array(
                        "status_code" => "ALLOK2",
                        "data" => array(
                            "alias" => $error['message'],
                            "email" => "NULL",
                            "accountNumber" => "NULL",
                            "ifscCode" => "NULL",
                            "creationDateTime" => "NULL"
                        )
                    );
                }
                /*                if (isset($result['beneficiary_alias'])) {
                    return array(
                        "status_code" => "ALLOK2",
                        "data" => array(
                            "alias" => $result['beneficiary_alias'],
                            "email" => $result['beneficiary_email'],
                            "accountNumber" => $result['beneficiary_account_no'],
                            "ifscCode" => $result['bank_code'],
                            "creationDateTime" => $result['created_at']
                        )
                    );
                } else {
                    return $status::BeneficiaryNotExist;
                }
*/
            }
        }
    }

    public function delete_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        $otpref = $data['data']['otp_response'];
        // check for session
        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        } else {
            // check for otp reference
            $result = $this->db->query(
                "
                SELECT
                    account.user_id_fk as userid,
                    account.id_pk as accountid,
                    otp.otp_purpose as purpose,
                    otp.verified as verified,
                    otp.otp_timestamp as otptime
                FROM
                    otp_master as otp
                RIGHT JOIN account_details as account
                    ON otp.user_details_id_fk = account.user_details_id_fk
                WHERE
                    otp.otp_ref = ?",
                array($otpref)
            )->row_array();
            $stmt = $this->db->query(
                "
                DELETE FROM otp_master
                WHERE otp_ref = ?",
                array($otpref)
            );
            // owner was found
            if (isset($result['accountid'])) {
                // check purpose
                if ($result['purpose'] != '2') {
                    return $status::InvalidOtpPurpose;
                }
                // check if verified
                if ($result['verified'] != '1') {
                    return $status::InvalidOtpPurpose;
                }
                // match otp_ref_id with session
                if ($accountid == $result['accountid']) {
                    // check for otp response validity
                    if (time() - $result['otptime'] > $this::OTP_REF_EXPIRY) {
                        return $status::ExpiredOtpResponse;
                    }
                    // check if beneficiary exists
                    $userid = $result['userid'];
                    $result = $this->db->query(
                        "
                        SELECT id_pk
                        FROM beneficiary_details
                        WHERE user_id_fk = ? AND beneficiary_alias = ?",
                        array($userid, strtoupper($data['data']['alias']))
                    )->row_array();
                    if (isset($result['id_pk'])) {
                        // beneficiary was there. now delete
                        $stmt = $this->db->query(
                            "
                            DELETE FROM beneficiary_details
                            WHERE id_pk = ?",
                            array($result['id_pk'])
                        );
                        return array(
                            "status_code" => "ALLOK2",
                            "message" => "Success"
                        );
                    } else {
                        return $status::BeneficiaryNotExist;
                    }
                } else {
                    return $status::OtpSessionMismatch;
                }
            } else {
                return $status::InvalidOtpResponse;
            }
        }
    }

    public function pay_ben($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();
        $otpref = $data['data']['otp_response'];
        // check for session
        $payerid = is_valid_session($data['token']);
        if ($payerid == null) {
            return $status::InvalidSession;
        } else {
            // check for otp reference
            $result = $this->db->query(
                "SELECT
                    account.id_pk as accountid,
                    account.account_no as account_number,
                    account.account_balance as balance,
                    account.user_id_fk as userid,
                    otp.otp_purpose as purpose,
                    otp.verified as verified,
                    otp.otp_timestamp as otptime
                FROM
                    otp_master as otp
                RIGHT JOIN account_details as account
                    ON otp.user_details_id_fk = account.user_details_id_fk
                WHERE
                    otp.otp_ref = ?",
                array($otpref)
            )->row_array();
            $stmt = $this->db->query(
                "
                DELETE FROM otp_master
                WHERE otp_ref = ?",
                array($otpref)
            );
            if (isset($result['accountid'])) {
                // check purpose
                if ($result['purpose'] != '3') {
                    return $status::InvalidOtpPurpose;
                }
                // check if verified
                if ($result['verified'] != '1') {
                    return $status::InvalidOtpPurpose;
                }
                // match otp_ref_id with session
                if ($payerid == $result['accountid']) {
                    // check for otp response validity
                    if (time() - $result['otptime'] > $this::OTP_REF_EXPIRY) {
                        return $status::ExpiredOtpResponse;
                    }
                    // check if beneficiary exists
                    $userid = $result['userid'];
                    $payer_account = $result['account_number'];
                    $payer_balance = floatval($result['balance']);
                    $is_beneficiary = $this->db->query(
                        "
                        SELECT id_pk, beneficiary_account_no
                        FROM beneficiary_details
                        WHERE user_id_fk = ? AND beneficiary_alias = ?",
                        array($userid, $data['data']['alias'])
                    )->row_array();
                    if ($is_beneficiary['id_pk'] != null) {
                        // get payer id_pk
                        $payee = $this->db->query(
                            "SELECT id_pk, account_balance, account_no
                            FROM account_details
                            WHERE account_no = ?",
                            array($is_beneficiary['beneficiary_account_no'])
                        )->row_array();
                        $payeeid = $payee['id_pk'];
                        $payee_balance = floatval($payee['account_balance']);
                        $payee_account = $payee['account_no'];
                        // check if balance is sufficient
                        if ($payer_balance >= floatval($data['data']['amount'])) {
                            // fund transfer
                            $amount = floatval(number_format($data['data']['amount'], 2, ".", ""));
                            //commenting to make -ve transactions
                            // if ($amount < 1.00) {
                            //     return $status::MinTransactionNotMet;
                            // }
                            $payee_balance += $amount;
                            $payer_balance -= $amount;
                            $sql = "UPDATE account_details SET account_balance = ? WHERE id_pk = ?";
                            $send = $this->db->query($sql, array($payee_balance, $payeeid));
                            $recv = $this->db->query($sql, array($payer_balance, $payerid));
                            // make transaction reference
                            $all_chars = "01234567890";
                            $len = 10;
                            $name = "trans_ref";
                            $table = "transaction_master";
                            do {
                                $reference = "000000000";
                                for ($i = 0; $i < $len; $i++) {
                                    $reference[$i] = $all_chars[random_int(0, strlen($all_chars) - 1)];
                                }
                            } while ($this->db->query(
                                "SELECT id_pk FROM " . $table . " WHERE " . $name . " = ?",
                                array($reference)
                            )->row_array()['id_pk'] != null);
                            // entry in transaction_master
                            $complete = $this->db->query(
                                "
                                INSERT INTO transaction_master(
                                    trans_date,
                                    src_acct,
                                    dst_acct,
                                    trans_remark,
                                    trans_amt,
                                    trans_ref
                                ) VALUES (?, ?, ?, ?, ?, ?)",
                                array(
                                    date("Y-m-d"),
                                    $payer_account,
                                    $payee_account,
                                    $data['data']['remarks'],
                                    $amount,
                                    $reference
                                )
                            );
                            return array(
                                "status_code" => "ALLOK2",
                                "message" => "Success",
                                "data" => (object) array(
                                    "transaction_id" => $reference,
                                    "updated_balance" => $payer_balance
                                )
                            );
                        } else {
                            return $status::InsufficientBalance;
                        }
                    } else {
                        return $status::BeneficiaryNotExist;
                    }
                } else {
                    return $status::OtpSessionMismatch;
                }
            } else {
                return $status::InvalidOtpResponse;
            }
        }
    }
}
