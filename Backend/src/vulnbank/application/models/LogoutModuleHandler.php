<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class LogoutModuleHandler extends CI_Model
{

    public function validateParams($data)
    {
        $this->load->helper('request_response');
        $status = new status_codes();
        // *****************************************************
        // token
        if (!isset($data['token'])) {
            return $status::RequestParameterNotSet;
        }
        return array(
            "status_code" => "ALLOK1",
            "message" => "Valid params"
        );
    }

    public function logout_user($data)
    {
        $this->load->helper('session');
        $this->load->helper('request_response');
        $status = new status_codes();

        $account_id = is_valid_session($data['token']);
        if ($account_id == null) { return $status::InvalidSession;
        } else {
            $stmt = $this->db->query(
                "DELETE FROM  session_master
                WHERE session_id = ?",
                array($data['token'])
            );
            if ($this->db->error()['code'] != 0) {
                return $status::DbError;
            }
            return array('status_code' => 'ALLOK2');
        }
    }
}
