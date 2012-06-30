<?php

class Establecimiento_Modelo extends Modelo {

	public function __construct() {
	
		parent::__construct();
	}

	public function listaEstablecimientos() {
		
		return $this->bd->select('SELECT * FROM SARE_ESTABLECIMIENTOS');
	}
	
	public function listaUnEstablecimiento($id) {
		
		return $this->bd->select('SELECT * FROM SARE_ESTABLECIMIENTOS WHERE CODIGO = :id', array(':id' => $id));
	}
	
	public function crear($datos) {
		
		$this->bd->insert('SARE_ESTABLECIMIENTOS', array(
			'CODIGO' => (int)$datos["codigo"],
			'NOMBRE' => $datos["nombre"],
			'DIRECCION' => $datos["direccion"],
			'COMUNA' => (int)$datos["comuna"]
		));
	}
	
	public function editarGuardar($datos) {
			
		$postData = array(
			'CODIGO' => (int)$datos["codigo"],
			'NOMBRE' => $datos["nombre"],
			'DIRECCION' => $datos["direccion"],
			'COMUNA' => (int)$datos["comuna"]
		);
		
		$this->bd->update('SARE_ESTABLECIMIENTOS', $postData, "CODIGO = {$datos['codigo']}");
	}
	
	public function eliminar($id) {
	
		$tabla = "SARE_ESTABLECIMIENTOS";		
		$this->bd->delete($tabla, "CODIGO = '$id'");
	}
	
	/***********************************/
	/**************A J A X**************/
	/***********************************/
	
	public function ajaxListaEstablecimientos() {
		
		$resultado = $this->bd->select("SELECT se.codigo, se.nombre, se.direccion, sc.nombre_comuna, sp.nombre_provincia, sr.nombre_region
										FROM sare_establecimientos se, sare_comunas sc, sare_provincias sp, sare_regiones sr
										WHERE se.id_comuna = sc.id AND sc.id_provincia = sp.id AND sp.id_region = sr.id AND se.ESTADO = 1");
		echo json_encode($resultado);
	}
	
	public function ajaxListaUnEstablecimiento() {
	
		$id = (int)$_POST["codigo"];
		$resultado = $this->bd->select("SELECT se.codigo, se.nombre, se.direccion, se.id_comuna, sc.nombre_comuna, sc.id_provincia, sp.nombre_provincia, sp.id_region, sr.nombre_region
										FROM sare_establecimientos se, sare_comunas sc, sare_provincias sp, sare_regiones sr
										WHERE se.id_comuna = sc.id AND sc.id_provincia = sp.id AND sp.id_region = sr.id AND se.codigo = '$id'");
		echo json_encode($resultado);
	}
	
	public function ajaxCrear() {
		
		$this->bd->insert('SARE_ESTABLECIMIENTOS', array(
			'CODIGO' => (int)$_POST["codigo"],
			'NOMBRE' => $_POST["nombre"],
			'DIRECCION' => $_POST["direccion"],
			'ID_COMUNA' => (int)$_POST["comuna"]
		));
		
		$data = array(
			'CODIGO' => (int)$_POST["codigo"],
			'NOMBRE' => $_POST["nombre"],
			'DIRECCION' => $_POST["direccion"],
			'ID_COMUNA' => (int)$_POST["comuna"],
			'ID_PROVINCIA' => (int)$_POST["provincia"],
			'ID_REGION' => (int)$_POST["region"]
		);
			
		echo json_encode($data);
	}
	
	public function ajaxEditarGuardar() {
	
		$postData = array(
			'CODIGO' => (int)$_POST["codigo"],
			'NOMBRE' => $_POST["nombre"],
			'DIRECCION' => $_POST["direccion"],
			'ID_COMUNA' => (int)$_POST["comuna"]
		);
		//print_r($postData);
		$this->bd->update('SARE_ESTABLECIMIENTOS', $postData, "CODIGO = {$_POST['codigo']}");
	
	}
	
	public function ajaxDeshabilitar() {
	
		$postData = array('ESTADO' => 0);
		//print_r($postData);
		$this->bd->update('SARE_ESTABLECIMIENTOS', $postData, "CODIGO = {$_POST['codigo']}");
	
	}
	
	public function ajaxEliminar() {
		
		$id = (int)$_POST["codigo"];
		$tabla = 'SARE_ESTABLECIMIENTOS';
		$this->bd->delete($tabla, "CODIGO = '$id'");
	}
	
	public function selectRegiones() {
	
		$resultado = $this->bd->select("SELECT * FROM SARE_REGIONES");
		echo json_encode($resultado);
	}
	
	public function selectProvincias() {
		
		$id = (int)$_GET["id"];
		$resultado = $this->bd->select("SELECT * FROM SARE_PROVINCIAS WHERE ID_REGION = '$id'" );
		echo json_encode($resultado);
	}
	
	public function selectComunas() {
		
		$id = (int)$_GET["id"];
		$resultado = $this->bd->select("SELECT * FROM SARE_COMUNAS WHERE ID_PROVINCIA = '$id'" );
		echo json_encode($resultado);
	}
}