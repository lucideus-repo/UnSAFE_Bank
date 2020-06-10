<?php

function get_sessionId($data)
{
    if (!isset($data['token'])) {
        return null;
    }
    return $data['token'];
}

/*
 * This function checks the validity of session token
 * return value:   account_details.id_pk for a valid session
 *                 NULL for an invalid session
 * @@params:       $sessionId => session token
 */

function is_valid_session($sessionId)
{
    $CI =& get_instance();
    $CI->load->database();
    // session timeout 10 mins i.e. 600 seconds
    // updated: 1 min i.e. 60s @18-Mar-2019
    // updated: 5 min i.e. 300s @20-Mar-2019
    // updated: 15 mn i.e 900s @13-May-2020
    $SESSION_TIMEOUT = 900;

    $stmt = $CI->db->query(
        "SELECT
            account_details.id_pk,
            session_master.last_access
        FROM
            session_master
        RIGHT JOIN user as u
            ON session_master.cust_id = u.cust_id
        RIGHT JOIN account_details
            ON u.id_pk = account_details.user_id_fk
        WHERE
            session_master.session_id = ?", array($sessionId)
    );
    $session = $stmt->row_array();

    // if the session was there
    if (isset($session['last_access'])) {
        $last_access = $session['last_access'] + 0;
        // check for timeout
        if (time() - $last_access >= $SESSION_TIMEOUT) {
            // delete  that session
            $stmt = $CI->db->query(
                "DELETE FROM session_master
                WHERE session_id = ?",
                array($sessionId)
            );
            return null;
        } else {
            // update that session
            $stmt = $CI->db->query(
                "UPDATE session_master
                SET last_access = ?
                WHERE session_id = ?",
                array(strval(time()), $sessionId)
            );
            return $session['id_pk'];
        }
    } else {
        return null;
    }
}

function idpk_from_accno($accno)
{

    $CI =& get_instance();
    $CI->load->database();

    $stmt = $CI->db->query(
        "
        SELECT
            id_pk
        FROM
            account_details
        WHERE
            acctNo = '" . $accno . "'"
    );
    return $stmt->row_array()['id_pk'];
}

?>
