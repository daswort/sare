<?php

class Inicio extends Controlador {

	function __construct() {
		parent::__construct();
		
		Sesion::iniciar();
		$estadoLogeo = Sesion::get('logeado');
		
		if ($estadoLogeo == false) {
			Sesion::destruir();
			header('location: ' . URL . 'login');
			exit;
		}
	}
	
	function index() {
		$this->vista->mostrar('inicio/index');
	}	
}