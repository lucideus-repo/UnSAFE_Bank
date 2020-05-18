<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Show extends CI_Controller
{
    public function index()
    {
        $file = BASEPATH."../../".$this->input->get("file");
        $content = @file_get_contents($file);
        if ($content === false) {
            print_r("File not found");
        }
        else {
            print_r($content);
        }
    }
    
}