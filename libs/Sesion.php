<?php

class Sesion {
	
	public static function iniciar() {
		@session_start();
	}
	
	public static function set($key, $value = false) {
		$_SESSION[$key] = $value;
	}
	
	public static function get($key) {
		if (isset($_SESSION[$key]))
		return $_SESSION[$key];
	}
	
	public static function destruir() {
		//unset($_SESSION);
		session_destroy();
	}
	
}