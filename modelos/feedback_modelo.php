<?php

class Feedback_Modelo extends Modelo {

  public function __construct() {

    parent::__construct();
  }

  public function paFeedback() {

  }

  public function selectCursos() {

    $nivel = $_GET['nivel'];
    $resultado = $this->bd->select("SELECT DISTINCT grado_curso, letra_curso, nivel_curso 
									FROM sare_clases
									WHERE nivel_curso = '$nivel'");
    echo json_encode($resultado);
  }

  public function selectAsignaturas() {

    $resultado = $this->bd->select("SELECT DISTINCT sa.codigo, sa.nombre 
									FROM sare_clases sc, sare_asignaturas sa
									WHERE sa.codigo = sc.codigo_asig
									AND sc.grado_curso = '" . $_GET['grado'] . "'
									AND sc.letra_curso = '" . $_GET['letra'] . "'
									AND sc.nivel_curso = '" . $_GET['nivel'] . "'");
    echo json_encode($resultado);
  }
  
  public function procesarExcel($datosEval, $datosAlum) {
    
	error_reporting(0);
	foreach($datosAlum as $key=>$value){
	  if($value['A'] == 0) continue;
	  $rutExcel[] = $value['A'];
	  $nombreExcel[] = $value['B'];
	}
	$rutBd = $this->bd->select("SELECT rut_alum 
								FROM sare_alumnos");
	if(empty($rutBd)){
	  $rutBd = array(0);
	}
	foreach($rutBd as $value){
	  $rutExisten[] = $value['RUT_ALUM'];
	}	
	$rutNoExisten = array_diff($rutExcel, $rutExisten); 
	print_r($rutNoExisten);
	$j = 0; $i = 0;
	foreach($datosAlum as $value){
	  if($value['A'] == 0) continue;
	  if($rutNoExisten[$j] == $value['A']){   
		$nom[] = explode(" ", $value['B']);
		$x = count($nom[$i]);
		$amaterno[] = $nom[$i][$x-1];
		$apaterno[] = $nom[$i][$x-2];
		$primerNom[] = $nom[$i][0];
		for($p = $x - 2; $p < $x; $p++){
			unset($nom[$i][$p]);
        }
		$nombreCompleto[] = implode(" ", $nom[$i]);
		$insert[] = "INTO sare_usuarios VALUES('" . $rutNoExisten[$j] . "','" . strtolower($nombreCompleto[$i]) . "','" . strtolower($apaterno[$i]) . "','" . strtolower($amaterno[$i]) . "','4','" . strtolower($primerNom[$i].".".$apaterno[$i].$i) . "','" . Hash::crear('sha256', $rutNoExisten[$j], HASH_PASSWORD_KEY) . "','" . strtolower($nom[$i][0].".".$nom[$i][2].$i) . "@sare.cl','1') ";
	    $insert[] = "INTO sare_alumnos VALUES('" . $rutNoExisten[$j] . "','','') ";
		$i++;
	  }
	  $j++;
	}
	$existeCurso = $this->bd->select("SELECT DISTINCT grado_curso, letra_curso, nivel_curso
									  FROM sare_matriculas
									  WHERE grado_curso = '" . $datosEval['curso'][0] . "'
									  AND letra_curso = '" . $datosEval['curso'][1] . "'
									  AND nivel_curso = '" . $datosEval['curso'][2] . "'");
	
	if(empty($existeCurso)) {
	  $codigo = $this->bd->select("SELECT codigo_estab 
		   						   FROM sare_administrativos 
								   WHERE rut_adm = '" . Sesion::get('id') . "'");
	  $profeJefe = $this->bd->select("SELECT DISTINCT rut_prof, anio_clase
									  FROM sare_clases
									  WHERE ej = 1
									  AND grado_curso = '" . $datosEval['curso'][0] . "'
									  AND letra_curso = '" . $datosEval['curso'][1] . "'
									  AND nivel_curso = '" . $datosEval['curso'][2] . "'");
	  foreach($datosAlum as $key=>$value){
	    if($value['A'] == 0) continue;
	    $insert[] = "INTO sare_matriculas VALUES('" . $profeJefe[0]['RUT_PROF'] . "','" . $codigo[0]['CODIGO_ESTAB'] . "','" . $datosEval['curso'][0] . "','" . $datosEval['curso'][1] . "','" . $datosEval['curso'][2] . "','" . $profeJefe[0]['ANIO_CLASE'] . "','" . $value['A'] . "')";
	  }
	}
	$unidades = $this->bd->select("SELECT codigo_unid 
								   FROM sare_unidades 
								   WHERE codigo_asig = '" . $datosEval['asignatura'] . "'");
	$profesor = $this->bd->select("SELECT DISTINCT rut_prof 
								   FROM sare_clases 
								   WHERE codigo_asig = '" . $datosEval['asignatura'] . "'");
	for($i = 1; $i <= count($datosAlum); $i++){
		$ojala[] = array_values($datosAlum[$i]);
	}
	$error = 0;
	for($i = 0; $i < count($ojala); $i++){
	  $validar[] = $ojala[0][$i+2];
	  for($j = 2; $j <= count($unidades)+1; $j++){
		$puntajes[$i][$j-2] = $ojala[$i][$j];
	  }	
	}
	for($i = 0; $i < count($validar); $i++){
	  $valor = $validar[$i];
	  if(!empty($valor)){
	    $unidadesExcel[] = $valor;
	  }
	}
	if(count($unidades) != count($unidadesExcel)){
	  $error = 1;
	}
	if($error == 1) {
	  echo "<p>Formato excel no corresponde al n&uacute;mero de unidades de la asignatura.<br> Por favor revise el archivo.</p>";
	  exit;
	}
	$i = 1;
	foreach($datosAlum as $rut){ 
	  if($rut['A'] == 0) continue;
	  for($j = 0; $j < count($puntajes[0]); $j++){
	    $insert[] = "INTO sare_evaluaciones VALUES ('" . $rut['A'] . "','" . $profesor[0]['RUT_PROF'] . "','" . $datosEval['asignatura'] . "','" . $puntajes[0][$j] . "','" . $datosEval['curso'][0] . "','" . $datosEval['curso'][1] . "','" . $datosEval['curso'][2] . "',to_date('" . $datosEval['fecha-eval'] . "','yyyy/mm/dd'),'" . $puntajes[$i][$j] . "') ";
	  }
	  $i++;
	}
	echo '<table id="tabla-excel" class="table table-striped">';  
    foreach ($datosAlum as $key=>$value) {
      echo '<tr>';
      foreach($value as $key=>$value){
        echo '<td>';
        echo $value;
        echo '</td>';
      }
      echo '</tr>';
    }   
    echo '</table>';
	$this->bd->insertAll($insert);
	echo '<pre>';
	// echo count($unidades);
    // echo count($puntajes);
    // print_r($datosAlum);
	// print_r($ojala);
	// print_r($puntajes);
	//print_r($nombreCortado);
	// print_r($rutExcel);
	//print_r($insert);
  }
}