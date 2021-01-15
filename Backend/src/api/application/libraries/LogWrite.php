<?php

defined('BASEPATH') or exit('No direct script access allowed');

class LogWrite
{
	public $logfile = null;
	public $logdata = null;

	public function __construct($logfile, $logdata)
	{
		if ($logfile !== "") {
			$this->logfile = $logfile;
		}
		$this->logdata = $logdata;
	}

	public function __destruct()
	{
		$file = APPPATH . 'logs/' . 'log.txt';
		if ($this->logfile !== null && $this->logfile !== '') {
			$file = APPPATH . 'logs/' . $this->logfile;
		}
		file_put_contents($file, $this->logdata, FILE_APPEND);
		chmod($file, 0777);
	}
}
