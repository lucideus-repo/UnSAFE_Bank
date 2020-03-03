<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Model_Statement extends CI_Model
{
    private function valid_date($date, $format='Y-m-d')
    {
        $d = DateTime::createFromFormat($format, $date);
        return $d && $d->format($format) === $date;
    }

    public function validate_all($data)
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

    public function validate_filtered($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::NoToken;
        }
        // *****************************************************
        // from_date
        if (isset($data['data']['from_date'])) {
            if(!$this::valid_date($data['data']['from_date'])) {
                return $status::InvalidFromDate;
            }
            else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // to_date
        if (isset($data['data']['to_date']))  {
            if(!$this::valid_date($data['data']['to_date'])) {
                return $status::InvalidToDate;
            }
            else {
            }
        } else { return $status::RequestParameterNotSet;
        }
        // *****************************************************
        // trans_type
        if (isset($data['data']['trans_type']))  {
            if(!in_array(
                $data['data']['trans_type'],
                ['CREDIT', 'DEBIT', 'ALL'])) {
                    return $status::InvalidTransType;
            }
            else {
            }
        } else { $status::RequestParameterNotSet;
        }
        // **************** ALL DONE **************************
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function get_all($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();

        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        }
        $account_number = $this->db->query(
            "SELECT account_no FROM account_details WHERE id_pk = ?",
            array($accountid)
        )->row_array()['account_no'];
        $debit_sql =
            "SELECT
                trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'DEBIT' as type
            FROM transaction_master
            WHERE src_acct = ?";
        $credit_sql =
            "SELECT
                trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'CREDIT' as type
            FROM transaction_master
            WHERE dst_acct = ?";
        $debits = $this->db->query(
            $debit_sql,
            array($account_number)
        )->result_array();
        $credits = $this->db->query(
            $credit_sql,
            array($account_number)
        )->result_array();
        $statement = array();
        foreach ($debits as $debit) {
            array_push($statement, $debit);
        }
        foreach ($credits as $credit) {
            array_push($statement, $credit);
        }
        return array(
            "status_code" => "ALLOK2",
            "message" => "Success",
            "data" => $statement
        );
    }

    public function get_filtered($data)
    {
        $this->load->helper('request_response');
        $this->load->helper('session');
        $status = new status_codes();

        $accountid = is_valid_session($data['token']);
        if ($accountid == null) {
            return $status::InvalidSession;
        }
        // check if (to_date >= from_date)
        $from_date = new DateTime($data['data']['from_date']);
        $to_date = new DateTime($data['data']['to_date']);
        if ($from_date > $to_date) {
            return $status::ToDateSmaller;
        }
        // check if (to_date - from_date) <= 180
        if ((int)$from_date->diff($to_date)->format('%d') > 180) {
            return $status::DiffMoreThanExpected;
        }
        // convert dates
        $from_date = $from_date->format('Y-m-d');
        $to_date = $to_date->format('Y-m-d');
        $account_number = $this->db->query(
            "SELECT account_no FROM account_details WHERE id_pk = ?",
            array($accountid)
        )->row_array()['account_no'];
        // build queries
        $debit_sql =
            "SELECT
                trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'DEBIT' as type
            FROM transaction_master
            WHERE src_acct = ? AND trans_date BETWEEN ? and ?
            ORDER BY tDate ASC";
        $credit_sql =
            "SELECT
                trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'CREDIT' as type
            FROM transaction_master
            WHERE dst_acct = ? AND trans_date BETWEEN ? and ?
            ORDER BY tDate ASC";
        $all_sql = 
            "SELECT
                trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'DEBIT' as type
            FROM transaction_master
            WHERE src_acct = ? AND trans_date BETWEEN ? and ?
            UNION (SELECT
            trans_date as tDate,
                dst_acct as fromToAcc,
                trans_remark as remarks,
                trans_amt as amount,
                trans_ref as referenceNo,
                'CREDIT' as type
            FROM transaction_master
            WHERE dst_acct = ? AND trans_date BETWEEN ? and ?)
            ORDER BY tDate ASC";
        // trans_type
        switch ($data['data']['trans_type']) {
            case 'DEBIT':
                $statement = $this->db->query(
                    $debit_sql,
                    array($account_number, $from_date, $to_date)
                )->result_array();
                break;
            case 'CREDIT':
                $statement = $this->db->query(
                    $credit_sql,
                    array($account_number, $from_date, $to_date)
                )->result_array();
                break;
            case 'ALL':
                $statement = $this->db->query(
                    $all_sql,
                    array($account_number, $from_date, $to_date, $account_number, $from_date, $to_date)
                )->result_array();
                break;
            default:
                break;
        }
        return array(
            "status_code" => "ALLOK2",
            "message" => "Success",
            "data" => $statement
        );
    }
}
