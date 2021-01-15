<?php
defined('BASEPATH') or exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class ContactUs extends CI_Controller
{
    public function aa(){
        $this->load->helper('request_response');
        $headers = request_parse();
       

        echo json_encode($headers);
    }

    public function index()
    {
        $this->load->helper('global_methods');
        $this->load->helper('request_response');
        $headers = getRequestHeaders();
        $data = file_get_contents('php://input');
        if (isJson($data)) {
            $post = json_decode(file_get_contents('php://input'), true);
            $data = array('status_code' => 'ALLOK1');
            foreach ($post['requestBody'] as $key => $value) {
                $data[$key] = $value;
            }
            $data = $data['data'];

            if (array_key_exists("name", $data)) {
                $message = 'Thanks for contacting us ' . $data["name"] . '. We will get back to you soon!';
                echo prepare_response(
                    "Success",
                    "CTS001",
                    $message,
                    time(),
                    array()
                );
            } else {
                echo prepare_response(
                    "Failed",
                    "CTS002",
                    "Error while submitting the response",
                    time(),
                    array()
                );
            
            }
        } elseif (array_key_exists("accept", $headers) && $headers["accept"] == 'application/xml') {

            $xmlfile = file_get_contents('php://input');
            $dom = new DOMDocument();
            $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
            $xmlData = simplexml_import_dom($dom);
            if (isset($xmlData->name)) {
                $name = $xmlData->name;
                $message = 'Thanks for contacting us ' . $name . '. We will get back to you soon!';
                echo prepare_response(
                    "Success",
                    "CTS001",
                    $message,
                    time(),
                    array()
                );
            } else {
                echo prepare_response(
                    "Failed",
                    "CTS002",
                    "Error while submitting the response",
                    time(),
                    array()
                );
            }
        } else {
            echo prepare_response(
                "Failed",
                "CTS002",
                "Error while submitting the response",
                time(),
                array()
            );
        }   
    }
}
