<?php

class Modelo {

  function __construct() {

    $this->bd = new Bd(BD_USUARIO, BD_PASS, BD_HOST);
    $this->bd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	$this->pdf = new FPDF();
  }
}