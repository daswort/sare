<?php

class Error extends Controlador {

	function __construct() {
		parent::__construct();
	}
	
	function index() {
		$this->vista->msg = 'Error 404... esta p&aacute;gina no existe';
		$this->vista->mostrar('error/index');
	}

}