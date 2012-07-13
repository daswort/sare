<?php

class Feedback extends Controlador {

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

    $this->vista->js = array('feedback/js/default.js');
  }

  public function index()  {

    $this->vista->mostrar('feedback/index');
  }

  public function paFeedback() {

    $this->modelo->paFeedback();
  }

  public function selectCursos() {

    $this->modelo->selectCursos();
  }

  public function selectAsignaturas() {

    $this->modelo->selectAsignaturas();
  }

  public function insertMatriculas() {
	
	$this->modelo->insertMatriculas();
  }

  public function procesarExcel() {

    //$fecha = strftime("%d%m%Y%H%M%S", time());
    $inputFileName = $_FILES["fichero"]["tmp_name"];
    $destino = "./archivos/excel.xlsx";
    move_uploaded_file($inputFileName,$destino);
    $inputFileName = "./archivos/excel.xlsx";

    echo 'Archivo guardado con el nombre: ',pathinfo($inputFileName,PATHINFO_BASENAME),'<br />';

    $objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
    echo '<hr />';
    echo '-------------------------------- Procesando Archivo --------------------------------------------<br />';
    $datosAlum = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
    $datosEval['curso'] = $_POST['curso'];
    $datosEval['asignatura'] = $_POST['asignatura'];
    $datosEval['fecha-eval'] = $_POST['fecha-eval'];
    $this->modelo->procesarExcel($datosEval, $datosAlum);
  }
}