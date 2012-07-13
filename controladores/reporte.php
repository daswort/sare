<?php

class Reporte extends Controlador {

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

    $this->vista->js = array('reporte/js/default.js');
  }

  public function index()  {

    $this->vista->mostrar('reporte/index');
  }
  
  public function dibujaGrafico() {
  
    $this->modelo->dibujaGrafico();
  }
  
  public function muestraForm() {
  
    switch($_GET['opcion']){
	  case '#cursobasica':
		require 'vistas/reporte/_cursoBasica.php';
	  break;
	  case '#cursomedia':
		require 'vistas/reporte/_cursoMedia.php';
	  break;
	  case '#asigbasica':
		require 'vistas/reporte/_asigBasica.php';
	  break;
	  case '#asigmedia':
		require 'vistas/reporte/_asigBasica.php';
	  break;
	  case '#alumbasica':
		require 'vistas/reporte/_alumnoBasica.php';
	  break;
	  case '#alummedia':
		require 'vistas/reporte/_alumnoBasica.php';
	  break;
	}
  }
  
   public function listaCursos() {
     
	  $this->modelo->listaCursos();
   }
   
   public function listaAlumnos() {
   
      $this->modelo->listaAlumnos();
   }
  
  public function generarReportePdf(){
	
	$this->modelo->generarReportePdf();
	// $this->pdf->AddPage();
	// $this->pdf->SetFont('Arial','B',16);
	// $this->pdf->Cell(40,10,'¡Hola, Mundo!');
	// $this->pdf->Output( "sample.pdf", "I" );
  }
}