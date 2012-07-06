<?php

class Feedback_Modelo extends Modelo {

  public function __construct() {

    parent::__construct();
  }

  public function paFeedback() {

  }

  public function selectCursos() {

    $nivel = $_GET['nivel'];
    $resultado = $this->bd->select("SELECT * FROM sare_cursos WHERE nivel = '$nivel'");
    echo json_encode($resultado);
  }

  public function selectAsignaturas() {

    $nivel = strtoupper($_GET['nivel']);
    $grado = strtoupper($_GET['grado']);
    $resultado = $this->bd->select("SELECT * FROM sare_asignaturas WHERE substr(codigo ,-1) = '$nivel' AND substr(substr(codigo, -2), 0, 1) = '$grado'");
    echo json_encode($resultado);
  }
  
  public function procesarExcel($datos) {
    
    if ($datos['curso-b'] == 0 && $datos['asignatura-b'] == 0) {
      unset($datos['curso-b'], $datos['asignatura-b']);
    } 
    if ($datos['curso-m'] == 0 && $datos['asignatura-m'] == 0) {
      unset($datos['curso-m'], $datos['asignatura-m']);
    }
    
    //echo '<pre>';
    //print_r($datos);
  }
}