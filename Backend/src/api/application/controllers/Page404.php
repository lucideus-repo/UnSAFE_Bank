<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/REST_Controller.php';

class Page404 extends CI_Controller {

    public function index()
    {
        echo "<pre>";
        echo "The requested page does not exist.\n";
        echo "Please contact the developers.";
        echo "</pre>";
    }
}