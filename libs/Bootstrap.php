<?php

class Bootstrap {

  function __construct() {

    $url = isset($_GET['url']) ? $_GET['url'] : null;
    $url = rtrim($url, '/');
    $url = filter_var($url, FILTER_SANITIZE_URL);
    $url = explode('/', $url);

    if (empty($url[0])) {
      require 'controladores/inicio.php';
      $controlador = new Inicio();
      $controlador->index();
      return false;
    }

    $file = 'controladores/' . $url[0] . '.php';
    if (file_exists($file)) {
      require $file;
    } else {
      $this->error();
    }

    $controlador = new $url[0];
    $controlador->cargarModelo($url[0]);

    // llamando a los métodos
    if (isset($url[2])) {
      if (method_exists($controlador, $url[1])) {
        $controlador->{$url[1]}($url[2]);
      } else {
        $this->error();
      }
    } else {
      if (isset($url[1])) {
        if (method_exists($controlador, $url[1])) {
          $controlador->{$url[1]}();
        } else {
          $this->error();
        }
      } else {
        $controlador->index();
      }
    }
  }

  public function error() {

    require 'controladores/error.php';
    $controlador = new Error();
    $controlador->index();
    return false;
  }
}