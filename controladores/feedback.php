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

  public function cargarExcel() {


  }

  public function procesarExcel() {

    $fecha = strftime("%d%m%Y%H%M%S", time());
    $inputFileName = $_FILES["fichero"]["tmp_name"];
    $destino = "./archivos/excel" . $fecha . ".xlsx";
    move_uploaded_file($inputFileName,$destino);
    $inputFileName = "./archivos/excel" . $fecha . ".xlsx";

    echo 'Archivo guardado con el nombre: ',pathinfo($inputFileName,PATHINFO_BASENAME),'<br />';


    $objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
    echo '<hr />';
    echo '-------------------------------- Procesando Archivo --------------------------------------------<br />';
    $alumnos = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
    $datos = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
    $datos['curso-b'] = $_POST['curso-b'];
    $datos['curso-m'] = $_POST['curso-m'];
    $datos['asignatura-b'] = $_POST['asignatura-b'];
    $datos['asignatura-m'] = $_POST['asignatura-m'];
    //$datos['fecha-eval'] = $_POST['fecha-eval'];
    $this->modelo->procesarExcel($datos);
    $filas = count($alumnos);
    $columnas = count($alumnos[1]);
    
    echo '<table id="tabla-excel" class="table table-striped">';
    
    foreach ($alumnos as $key=>$value) {
      echo '<tr>';
      foreach($value as $key=>$value){
        echo '<td>';
        echo $value;
        echo '</td>';
      }
      echo '</tr>';
    }
    
    echo '</table>';
  }
}