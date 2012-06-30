<?php

class Login extends Controlador {

	function __construct() {
	
		parent::__construct();
		Sesion::iniciar();
		$estadoLogeo = Sesion::get('logeado');
		
		if ($estadoLogeo == true && $_GET['url'] == 'login') {
			header('location: ' . URL . 'inicio');
		}
	}
	
	function index() {	
	
		$this->vista->mostrar('login/index');
	}
	
	function logear() {
	
		$this->modelo->logear();
	}	
	
	function deslogear() {
	
		$this->modelo->deslogear();
	}
}