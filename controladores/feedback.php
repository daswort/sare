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

		//set_include_path('./libs/_php_excel/');
		
		$inputFileName = $_FILES["fichero"]["tmp_name"];
		$destino = "./archivos/excel.xlsx";
		move_uploaded_file($inputFileName,$destino);
		$inputFileName = './archivos/excel.xlsx';
		
		echo 'Loading file ',pathinfo($inputFileName,PATHINFO_BASENAME),' using IOFactory to identify the format<br />';
		
		
		$objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
		echo '<hr />';
		echo '-------------------------------- Procesando Archivo --------------------------------------------<br />';
		$alumnos = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
		
		$numAlumnos = count($alumnos);
		$datosAlumno = array();
		
		
		$contador = 0; // solo para eliminar la primera fila
		$puntajeTotal = 0;
		foreach ($alumnos as $value) {
			foreach ($value as $datos) {
				// guardamos la fila en un array
				$datosAlumno[] = $datos;
			}
			 
			if($contador == 0){
				unset($datosAlumno);
			}else{
				 
		
				for($a=0;$a<count($datosAlumno);$a++){
					$datosAlumno[$a];//todos los datos del alumno incluidos los puntajes.
				}
		
				 
				for($p=2 ; $p <count($datosAlumno);$p++){
					$unidad = "unidad$p";
					$$unidad = $datosAlumno[$p];
				}
		
		
				//sumar puntajes de unidades
				$puntajeTotal=0;
				for($p=2 ; $p <count($datosAlumno);$p++){
					$puntajeTotal = $puntajeTotal + $datosAlumno[$p];
				}
				echo " ".$rut = $datosAlumno[0];
				echo " ".$nombreCompleto = $datosAlumno[1];
		
				 
		
		
				//el nombre completo esta en un solo campo
				// por lo ke lo separo para poder procesar los apellidos aparte
				$cortarNombres = explode(" ",$nombreCompleto);
				$x = count($cortarNombres);
				//las 2 ultimas posiciones son el apellido paterno y materno respectivamente
				echo"<br />";
				echo "apellido materno ".$aMaterno = $cortarNombres[$x-1];
				echo"<br />";
				echo "apellido paterno ".$aPaterno = $cortarNombres[$x-2];
				echo "<br />";
				echo "nombre de usuario ". $userName = $cortarNombres[0].".".$aPaterno;
				echo "<br />";
				echo "password ".$passwd = $rut;// por ahora despues el administrador la cambia
		
				//elimino las 2 ultimas posiciones que corresponde a aPaterno y aMaterno
				for($j= $x-2; $j<$x; $j++){
					unset($cortarNombres[$j]);
				}
		
				//ahora el arreglo ya no posee los apellidos
				// y unimos los nombres en un string separados por espacios
				$nombres = implode(" ",$cortarNombres);
				echo "<br />Nombres: ";
				echo $nombres;
		
				//Unidades
				for($s=2; $s < count($datosAlumno); $s++){
					$w = $s-1;
					echo "<br />unidad$w: ";
					echo ${
					"unidad".$s};
					}
		
						echo "<br />Puntaje Total: ";
						echo $puntajeTotal;
						unset($datosAlumno);// mover al final
						echo "<br />";
			}//else contador
						$contador++; //
						echo"<br />";
						}
	}
}