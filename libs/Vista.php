<?php

class Vista {

	function __construct() {
		//echo 'esto es una vista';
	}

	public function mostrar($nombre, $noIncluir = false) {
		
		if ($noIncluir == true) {
			require 'vistas/' . $nombre . '.php';	
		} else {
			require 'vistas/header.php';
			require 'vistas/' . $nombre . '.php';
			require 'vistas/footer.php';	
		}
	}
}