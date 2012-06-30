<?php

class Login_Modelo extends Modelo {
	
	public function __construct() {
		
		parent::__construct();
	}

	public function logear() {
		
		$sth = $this->bd->prepare("SELECT PERMISO FROM SARE_USUARIOS WHERE USERNAME = :login AND PASSWD = :password AND ESTADO = 1");
		$sth->execute(array(':login' => $_POST['login'], ':password' => Hash::crear('sha256', $_POST['password'], HASH_PASSWORD_KEY)));
		
		$datos = $sth->fetch();
		
		if ($datos > 0) {
			Sesion::iniciar();
			Sesion::set('rol', $datos['PERMISO']);
			Sesion::set('logeado', true);
			Sesion::set('usuario', $_POST['login']);
			header('location: ' . URL . 'inicio');
		} else {
			header('location: ' . URL . 'login');
			echo "<p>El nombre de usuario o la contrase&ntilde;a no corresponden.</p>";
		}
		
	}
	
	public function deslogear() {
		
		Sesion::destruir();
		header('location: ' . URL .  'login');
		exit;
	}
}