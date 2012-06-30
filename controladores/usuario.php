<?php

class Usuario extends Controlador {

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
		
		$this->vista->js = array('usuario/js/default.js');
	}
	
	public function index()  {	
		$this->vista->listaUsuarios = $this->modelo->listaUsuarios();
		$this->vista->mostrar('usuario/index');
	}
	
	public function crear() {
		$datos = array();
		$datos['rut'] = $_POST['rut'];
		$datos['nombres'] = $_POST['nombres'];
		$datos['ap-pat'] = $_POST['ap-pat'];
		$datos['ap-mat'] = $_POST['ap-mat'];
		$datos['usuario'] = $_POST['usuario'];
		$datos['email'] = $_POST['email'];
		$datos['password'] = $_POST['password'];
		
		switch ($_POST['permiso']) {
			case "adm":
				$datos['permiso'] = 2;
				break;
			case "prof":
				$datos['permiso'] = 3;
				break;
			case "alum":
				$datos['permiso'] = 4;
				break;
		}
		
		$this->modelo->crear($datos);
		header('location: ' . URL . 'usuario');
	}
	
	public function editar($id) {
		
		$this->vista->usuario = $this->modelo->listaUnUsuario($id);
		$this->vista->mostrar('usuario/editar');
	}
	
	public function editarGuardar($id) {
	
		$datos = array();
		$datos['rut'] = $id;
		$datos['nombres'] = $_POST['nombres'];
		$datos['ap-pat'] = $_POST['ap-pat'];
		$datos['ap-mat'] = $_POST['ap-mat'];
		$datos['usuario'] = $_POST['usuario'];
		$datos['email'] = $_POST['email'];
		$datos['password'] = $_POST['password'];
		
		switch ($_POST['permiso']) {
			case "adm":
				$datos['permiso'] = 2;
				break;
			case "prof":
				$datos['permiso'] = 3;
				break;
			case "alum":
				$datos['permiso'] = 4;
				break;
		}
		
		$this->modelo->editarGuardar($datos);
		header('location: ' . URL . 'usuario');
	}
	
	public function eliminar($id)	{
		
		$this->modelo->eliminar($id);
		header('location: ' . URL . 'usuario');
	}
	
	/***********************************/
	/**************A J A X**************/
	/***********************************/
	
	function ajaxListaUsuarios() {
	
		$this->modelo->ajaxListaUsuarios();
	}
	
	function ajaxListaUnUsuario() {
		
		$this->modelo->ajaxListaUnUsuario();
	}
	
	public function ajaxCrear() {
		
		$this->modelo->ajaxCrear();
	}
	
	public function paCrearUsuario() {
	
		$this->modelo->paCrearUsuario();
	}
	
	public function paEditarUsuario() {
		
		$this->modelo->paEditarUsuario();
	}
	
	public function ajaxEditarGuardar() {
	
		$this->modelo->ajaxEditarGuardar();
	}
	
	public function ajaxDeshabilitar() {
	
		$this->modelo->ajaxDeshabilitar();
	}
	
	function ajaxEliminar() {
		
		$this->modelo->ajaxEliminar();
	}
	
	function muestraForm(){
		
		switch ($_GET['id']) {
			case 2:
				require 'vistas/usuario/_formAdm.php';
			break;
			case 3:
				require 'vistas/usuario/_formProf.php';
			break;
			case 4:
				require 'vistas/usuario/_formAlum.php';
			break;
		}
	}
	
	function muestraLista(){
	
		switch ($_GET['id']) {
			case 2:
				require 'vistas/usuario/_listaAdm.php';
			break;
			case 3:
				require 'vistas/usuario/_listaProf.php';
			break;
			case 4:
				require 'vistas/usuario/_listaAlum.php';
			break;
		}
	}
	
	function muestraEditar() {
		
		switch ($_GET['id']) {
			case 2:
				require 'vistas/usuario/_editaAdm.php';
			break;
			case 3:
				require 'vistas/usuario/_editaProf.php';
			break;
			case 4:
				require 'vistas/usuario/_editaAlum.php';
			break;
		}
	}
}