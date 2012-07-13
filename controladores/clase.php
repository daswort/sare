<?php

class Clase extends Controlador {

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

    $this->vista->js = array('clase/js/default.js');
  }

  public function index()  {

    $this->vista->mostrar('clase/index');
  }
  
  public function selectCursos() {

    $this->modelo->selectCursos();
  }

  public function selectAsignaturas() {

    $this->modelo->selectAsignaturas();
  }
  
  public function verificaProfJefe() {
  
    $this->modelo->verificaProfJefe();
  }
  
  public function crearClase() {
	
	$this->modelo->crearClase();
  }
}