<?php

class Reporte_Modelo extends Modelo {

  public function __construct() {
    parent::__construct();
  }
  
  public function listaCursos() {
    
	switch($_GET['opcion']){
	    case 'b':
		  $resultado = $this->bd->select("SELECT DISTINCT grado_curso, letra_curso, nivel_curso
										  FROM sare_matriculas
										  WHERE nivel_curso = 'b'");
		  echo json_encode($resultado);
	    break;
	    case 'm':
		  $resultado = $this->bd->select("SELECT DISTINCT grado_curso, letra_curso, nivel_curso
										  FROM sare_matriculas
										  WHERE nivel_curso = 'm'");
		  echo json_encode($resultado);
	    break;
	}
  }
  
  public function listaAlumnos() {
  
	switch($_GET['curso'][2]) {
	  case "b":
	    $resultado = $this->bd->select("SELECT * 
										FROM sare_matriculas
										WHERE grado_curso = '" . $_POST['curso'][0] . "'
										AND letra_curso = '" . $_POST['curso'][1] . "'
										AND nivel_curso = '" . $_POST['curso'][2] . "'");
		echo json_enconde($resultado);
	  break;
	  
	  case "m":
	    $resultado = $this->bd->select("");
		echo json_enconde($resultado);
	  break;
	}
  }
  
  public function dibujaGrafico() {
	$resultado = $this->bd->select("SELECT se.rut_alum, su.nombres, su.apaterno, su.amaterno, se.codigo_asig, fecha_eval, SUM(se.puntaje_unid)
										FROM sare_evaluaciones se, sare_usuarios su
										WHERE se.rut_alum = su.rut
										AND grado_curso = '" . $_POST['curso'][0] . "'
										AND letra_curso = '" . $_POST['curso'][1] . "'
										AND nivel_curso = '" . $_POST['curso'][2] . "'");
	echo json_encode($resultado);
  }
  
  public function generarReportePdf(){
    
	switch($_POST['curso'][2]){
	  case 'b':
	    $resultado = $this->bd->select("SELECT se.rut_alum, su.nombres, su.apaterno, su.amaterno, se.codigo_asig, fecha_eval, SUM(se.puntaje_unid)
										FROM sare_evaluaciones se, sare_usuarios su
										WHERE se.rut_alum = su.rut
										AND grado_curso = '" . $_POST['curso'][0] . "'
										AND letra_curso = '" . $_POST['curso'][1] . "'
										AND nivel_curso = '" . $_POST['curso'][2] . "'
										GROUP BY se.rut_alum, su.nombres, su.apaterno, su.amaterno, se.rut_prof, se.codigo_asig, fecha_eval");
		$colegio = $this->bd->select("SELECT DISTINCT se.nombre
									  FROM sare_establecimientos se, sare_matriculas sm, sare_administrativos sa
									  WHERE se.codigo = sm.codigo_estab
									  AND sm.codigo_estab = sa.codigo_estab
									  AND se.codigo = sa.codigo_estab
 									  AND sa.rut_adm = '" . Sesion::get('id') . "'");
		
		$this->pdf->AddPage();
		$this->pdf->SetFont('Arial','B',16);
		$this->pdf->Cell(40,10,'Reporte Evaluaciones ' . $_POST['curso'][0] . ' Básico ' . strtoupper($_POST['curso'][1]) . ' del Colegio ' . ucwords($colegio[0]['NOMBRE']) . '.');
		$this->pdf->Ln(16);
		
		$this->pdf->SetFont('','',10);
		$cabecera = array('Rut Alumno', 'Nombre', 'Apellido Paterno', 'Apellido Materno', 'Asignatura', 'Fecha Eval', 'Puntaje');
		foreach($cabecera as $col)
          $this->pdf->Cell(28,7,$col,1);
        $this->pdf->Ln();
        
        foreach($resultado as $row) {
          foreach($row as $col)
            $this->pdf->Cell(28,6,$col,1);
          $this->pdf->Ln();
        }
		$this->pdf->Output( "sample.pdf", "I" );
	  break;
	  
	  case 'm':
	  
	  $resultado = $this->bd->select("SELECT se.rut_alum, su.nombres, su.apaterno, su.amaterno, se.codigo_asig, fecha_eval, SUM(se.puntaje_unid)
										FROM sare_evaluaciones se, sare_usuarios su
										WHERE se.rut_alum = su.rut
										AND grado_curso = '" . $_POST['curso'][0] . "'
										AND letra_curso = '" . $_POST['curso'][1] . "'
										AND nivel_curso = '" . $_POST['curso'][2] . "'
										GROUP BY se.rut_alum, su.nombres, su.apaterno, su.amaterno, se.rut_prof, se.codigo_asig, fecha_eval");
		$colegio = $this->bd->select("SELECT DISTINCT se.nombre
									  FROM sare_establecimientos se, sare_matriculas sm, sare_administrativos sa
									  WHERE se.codigo = sm.codigo_estab
									  AND sm.codigo_estab = sa.codigo_estab
									  AND se.codigo = sa.codigo_estab
 									  AND sa.rut_adm = '" . Sesion::get('id') . "'");
		
		$this->pdf->AddPage();
		$this->pdf->SetFont('Arial','B',16);
		$this->pdf->Cell(40,10,'Reporte Evaluaciones ' . $_POST['curso'][0] . ' Media ' . strtoupper($_POST['curso'][1]) . ' del Colegio ' . ucwords($colegio[0]['NOMBRE']) . '.');
		$this->pdf->Ln(16);
		
		$this->pdf->SetFont('','',10);
		$cabecera = array('Rut Alumno', 'Nombre', 'Apellido Paterno', 'Apellido Materno', 'Asignatura', 'Fecha Eval', 'Puntaje');
		foreach($cabecera as $col)
          $this->pdf->Cell(28,7,$col,1);
        $this->pdf->Ln();
        
        foreach($resultado as $row) {
          foreach($row as $col)
            $this->pdf->Cell(28,6,$col,1);
          $this->pdf->Ln();
        }
		$this->pdf->Output( "sample.pdf", "I" );
	  break;
	  break;
	}
  }
}