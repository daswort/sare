<?php

class Perfil extends Controlador {
	
	function __construct() {

		parent::__construct();
		Sesion::iniciar();
		$estadoLogeo = Sesion::get('logeado');
		$rol = Sesion::get('rol');
		
		if ($estadoLogeo == false) {
			Sesion::destruir();
			header('location: ' . URL . 'login');
			exit;
		}
		$this->vista->js = array('perfil/js/default.js');
	}

	function index() {
		
		$usuario = Sesion::get('usuario');
		$this->vista->perfil = $this->modelo->datosUsuario($usuario);
		$this->vista->mostrar('perfil/index');
	}
}