<?php

class Clase_Modelo extends Modelo {

  public function __construct() {
    parent::__construct();
  }
  
  public function selectCursos() {

    $nivel = $_GET['nivel'];
    $resultado = $this->bd->select("SELECT * 
									FROM sare_cursos 
									WHERE nivel = '$nivel'");
    echo json_encode($resultado);
  }
  
  public function selectAsignaturas() {

    $nivel = strtoupper($_GET['nivel']);
    $grado = strtoupper($_GET['grado']);
    $resultado = $this->bd->select("SELECT * 
									FROM sare_asignaturas 
									WHERE substr(codigo ,-1) = '$nivel' 
									AND substr(substr(codigo, -2), 0, 1) = '$grado'");
    echo json_encode($resultado);
  }
  
  public function crearClase() {
	
	$resultado = $this->bd->select("SELECT codigo_unid 
									FROM sare_unidades 
									WHERE codigo_asig = '" . $_POST['asignatura'] . "'");	
									
	if(isset($_POST['es-profe-jefe'])){
	  foreach($resultado as $value) {
	    $datos[] = "INTO sare_clases VALUES ('" . $_POST['profesor'] . "','" . $_POST['asignatura'] . "','" . $value['CODIGO_UNID'] . "','" . $_POST['anio'] . "','" . $_POST['curso'][0] . "','" . $_POST['curso'][1] . "','" . $_POST['curso'][2] . "','1') ";
	  }
	} else {
	  foreach($resultado as $value) {
	    $datos[] = "INTO sare_clases VALUES ('" . $_POST['profesor'] . "','" . $_POST['asignatura'] . "','" . $value['CODIGO_UNID'] . "','" . $_POST['anio'] . "','" . $_POST['curso'][0] . "','" . $_POST['curso'][1] . "','" . $_POST['curso'][2] . "','0') ";
	  }
	}
	//print_r($datos);
	$this->bd->insertAll($datos);
  }
  
  public function verificaProfJefe() {
	
	$resultado = $this->bd->select("SELECT DISTINCT ej
									FROM sare_clases
									WHERE rut_prof = '" . $_GET['rut-profesor'] . "'
									AND ej = 1");	
	echo json_encode($resultado);
  }
}