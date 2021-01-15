<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Model_Loan extends CI_Model
{



    public function validateParamsForLoan($parsedData)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************

        if (isset($parsedData["amount"])) {
            $amt = $parsedData['amount'];
            if ((strlen($amt) > 10)
                or !preg_match("/^[0-9]+(\.[0-9]{1,2})?$/", $amt)
            ) {
                return $status::AmountInvalid;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }

        if (!isset($parsedData["type"])) {
            return $status::LoanTypeInvalid;
        }

        if (isset($parsedData["roi"])) {
            $amt = $parsedData['roi'];
            if ((strlen($amt) > 10)
                or !preg_match("/^[0-9]+(\.[0-9]{1,2})?$/", $amt)
            ) {
                return $status::ROIInvalid;
            } else {
            }
        } else {
            return $status::RequestParameterNotSet;
        }

        if (isset($parsedData["tenure"])) {
            $amt = $parsedData['tenure'];
            if ((strlen($amt) > 10)
                or !preg_match("/^[0-9]+(\.[0-9]{1,2})?$/", $amt)
            ) {
                return $status::TenureInvalid;
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

    public function saveLoanDetails($accountId, $data, $unserialised)
    {
        $this->db->query("INSERT INTO loan_details (`user_id_fk`, `amount`, `roi`,`type`,`tenure`,`AppliedDate`) VALUES (?,?,?,?,?,?) ", array($accountId, $data['amount'], $data['roi'], $unserialised->logdata, $data['tenure'], date('Y-m-d')));
    }
    public function getLoanDetails($accountId)
    {
        $debits = $this->db->query(
            "SELECT `amount`,`roi`,`type`,`tenure`,`AppliedDate` from loan_details WHERE user_id_fk = ?",
            array($accountId)
        )->result_array();
        $statement = array();
        foreach ($debits as $debit) {
            array_push($statement, $debit);
        }
        return array(
            "status_code" => "ALLOK1",
            "message" => "Success",
            "data" => $statement
        );
    }
}
