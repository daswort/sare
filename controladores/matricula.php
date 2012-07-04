<?php

class Matricula extends Controlador {

	public function __construct() {

		parent::__construct();
		Sesion::iniciar();
		$estadoLogeo = Sesion::get('logeado');
		$rol = Sesion::get('rol');

		if ($estadoLogeo == false) {
			Sesion::destruir();
			header('location: ' . URL . 'login');
			exit;
		}

		$this->vista->js = array('matricula/js/default.js');
	}
	
	public function index()  {
		//$this->vista->listaUsuarios = $this->modelo->listaUsuarios();
		$this->vista->mostrar('matricula/index');
	}
}