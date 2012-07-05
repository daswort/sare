<?php

require 'config.php';

function __autoload($clase) {
	
	$rutaClase = LIBS . $clase . '.php';
	$rutaClaseExcel = LIBS . 'PHPExcel/' . $clase . '.php';
	
	if(file_exists($rutaClase)) {
		require $rutaClase;
	} elseif (file_exists($rutaClaseExcel)) {
		require $rutaClaseExcel;
	}
}

$app = new Bootstrap();