<?php

class Controlador {

	function __construct() {
		
		$this->vista = new Vista();
	}
	
	public function cargarModelo($nombre) {
		
		$ruta = 'modelos/'.$nombre.'_modelo.php';
		
		if (file_exists($ruta)) {
			require 'modelos/'.$nombre.'_modelo.php';
			
			$nombreModelo = $nombre . '_Modelo';
			$this->modelo = new $nombreModelo();
		}		
	}
}