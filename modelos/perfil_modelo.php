<?php

class Perfil_Modelo extends Modelo {

	public function __construct() {
		parent::__construct();
	}
	
	public function datosUsuario($usuario) {
		
		return $this->bd->select('SELECT * FROM SARE_USUARIOS WHERE USERNAME = :usuario', array(':usuario' => $usuario));
	}
}