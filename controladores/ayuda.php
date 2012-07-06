<?php

class Ayuda extends Controlador {

  function __construct() {

    parent::__construct();
    $this->vista->js = array('ayuda/js/default.js');
  }

  function index() {

    $this->vista->mostrar('ayuda/index');
  }
}