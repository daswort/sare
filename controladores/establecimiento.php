<?php

class Establecimiento extends Controlador {

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

    $this->vista->js = array('establecimiento/js/default.js');
  }

  public function index()  {

    $this->vista->listaEstablecimientos = $this->modelo->listaEstablecimientos();
    $this->vista->mostrar('establecimiento/index');
  }

  public function crear() {
    $datos = array();
    $datos['codigo'] = $_POST['codigo'];
    $datos['nombre'] = $_POST['nombre'];
    $datos['direccion'] = $_POST['direccion'];
    $datos['comuna'] = $_POST['comuna'];
    $datos['provincia'] = $_POST['provincia'];
    $datos['region'] = $_POST['region'];

    $this->modelo->crear($datos);
    header('location: ' . URL . 'establecimiento');

  }

  public function editar($id) {
    $this->vista->establecimiento = $this->modelo->listaUnEstablecimiento($id);
    //$this->vista->mostrar('establecimiento/editar');
  }

  public function editarGuardar($id) {

    $datos = array();
    $datos['codigo'] = $id;
    $datos['nombre'] = $_POST['nombre'];
    $datos['direccion'] = $_POST['direccion'];
    $datos['comuna'] = $_POST['comuna'];
    $datos['provincia'] = $_POST['provincia'];
    $datos['region'] = $_POST['region'];

    $this->modelo->editarGuardar($datos);
    header('location: ' . URL . 'establecimiento');

  }

  public function eliminar($id)	{

    $this->modelo->eliminar($id);
    header('location: ' . URL . 'establecimiento');
  }

  /***********************************/
  /**************A J A X**************/
  /***********************************/

  function ajaxListaEstablecimientos() {

    $this->modelo->ajaxListaEstablecimientos();
  }

  function ajaxListaUnEstablecimiento() {
    $this->modelo->ajaxListaUnEstablecimiento();
  }

  public function ajaxCrear() {

    $this->modelo->ajaxCrear();
  }

  public function ajaxEditarGuardar() {

    $this->modelo->ajaxEditarGuardar();
  }

  public function ajaxDeshabilitar() {

    $this->modelo->ajaxDeshabilitar();
  }

  public function ajaxEliminar() {

    $this->modelo->ajaxEliminar();
  }

  public function selectRegiones() {

    $this->modelo->selectRegiones();
  }

  public function selectProvincias() {

    $this->modelo->selectProvincias();
  }

  public function selectComunas() {

    $this->modelo->selectComunas();
  }

  public function muestraForm() {

    require 'vistas/establecimiento/_formEstab.php';
  }

  public function muestraLista() {

    require 'vistas/establecimiento/_listaEstab.php';
  }

  public function muestraEditar() {

    require 'vistas/establecimiento/_editaEstab.php';
  }
}