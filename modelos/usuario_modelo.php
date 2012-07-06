<?php

class Usuario_Modelo extends Modelo {

  public function __construct() {

    parent::__construct();
  }

  public function listaUsuarios() {

    return $this->bd->select('SELECT * FROM SARE_USUARIOS');
  }

  public function listaUnUsuario($id) {

    return $this->bd->select('SELECT * FROM SARE_USUARIOS WHERE RUT = :id', array(':id' => $id));
  }

  public function crear($datos) {

    $this->bd->insert('SARE_USUARIOS', array(
        'RUT' => (int)$datos["rut"],
        'NOMBRES' => $datos["nombres"],
        'APATERNO' => $datos["ap-pat"],
        'AMATERNO' => $datos["ap-mat"],
        'PERMISO' => (int)$datos["permiso"],
        'USERNAME' => $datos["usuario"],
        'PASSWD' => Hash::crear('sha256', $datos["password"], HASH_PASSWORD_KEY),
        'EMAIL' => $datos["email"]
    ));
  }

  public function editarGuardar($datos) {

    $postData = array(
        'RUT' => (int)$datos["rut"],
        'NOMBRES' => $datos["nombres"],
        'APATERNO' => $datos["ap-pat"],
        'AMATERNO' => $datos["ap-mat"],
        'PERMISO' => (int)$datos["permiso"],
        'USERNAME' => $datos['usuario'],
        'PASSWD' => Hash::crear('sha256', $datos['password'], HASH_PASSWORD_KEY),
        'EMAIL' => $datos["email"]
    );

    $this->bd->update('SARE_USUARIOS', $postData, "RUT = {$datos['rut']}");
  }

  public function eliminar($id) {

    $tabla = "SARE_USUARIOS";

    $result = $this->bd->select('SELECT PERMISO FROM ' . $tabla . ' WHERE RUT = :id', array(':id' => $id));

    if ($result[0]['PERMISO'] == 1) return false;

    $this->bd->delete($tabla, "RUT = '$id'");
  }

  /***********************************/
  /**************A J A X**************/
  /***********************************/

  public function ajaxListaUsuarios() {

    switch ($_GET['permiso']) {
      case "adm":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, sa.cargo, se.nombre
        FROM sare_usuarios su, sare_administrativos sa, sare_establecimientos se
        WHERE su.rut = sa.rut_adm AND se.codigo = sa.codigo_estab AND su.estado = 1");
        echo json_encode($resultado);
        break;
        	
      case "prof":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, sp.telefono
        FROM sare_usuarios su, sare_profesores sp
        WHERE su.rut = sp.rut_prof AND su.estado = 1");
        echo json_encode($resultado);
        break;
        	
      case "alum":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, sa.sexo, sa.direccion
        FROM sare_usuarios su, sare_alumnos sa
        WHERE su.rut = sa.rut_alum AND su.estado = 1");
        echo json_encode($resultado);
        break;
    }
  }

  public function ajaxListaUnUsuario() {

    $id = $_POST['id'];

    switch ($_POST['permiso']) {
      case "adm":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, su.passwd, sa.cargo, se.codigo, se.nombre
        FROM sare_usuarios su, sare_administrativos sa, sare_establecimientos se
        WHERE su.rut = sa.rut_adm AND se.codigo = sa.codigo_estab AND su.estado = 1 AND su.rut = '$id'");
        echo json_encode($resultado);
        break;
      case "prof":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, su.passwd, sp.telefono
        FROM sare_usuarios su, sare_profesores sp
        WHERE su.rut = sp.rut_prof AND su.estado = 1 AND su.rut = '$id'");
        echo json_encode($resultado);
        break;
        	
      case "alum":
        $resultado = $this->bd->select("SELECT su.rut, su.nombres, su.apaterno, su.amaterno, su.username, su.email, su.passwd, sa.sexo, sa.direccion
        FROM sare_usuarios su, sare_alumnos sa
        WHERE su.rut = sa.rut_alum AND su.estado = 1 AND su.rut = '$id'");
        echo json_encode($resultado);
        break;
    }
  }

  public function buscarUsuario() {

    switch ($_POST['tipo']) {
      case "por-rut":
        $dato = $_POST['rut'];
        $resultado = $this->bd->select("SELECT rut, nombres, apaterno, amaterno, username, email, permiso
            FROM sare_usuarios
            WHERE estado = 1 AND rut = '$dato'");
        if ($resultado == null) {
          $resultado = null;
          echo json_encode($resultado);
        } elseif($resultado != null) {
          switch ($resultado[0]["PERMISO"]){
            case 1:
              $resultado[0]["PERMISO"] = "Superusuario";
              break;
            case 2:
              $resultado[0]["PERMISO"] = "Administrativo";
              break;
            case 3:
              $resultado[0]["PERMISO"] = "Profesor";
              break;
            case 4:
              $resultado[0]["PERMISO"] = "Alumno";
              break;
          }
          echo json_encode($resultado);
        }
        break;
        	
      case "por-nom":
        $dato = $_POST['nombre'];
        $resultado = $this->bd->select("SELECT rut, nombres, apaterno, amaterno, username, email, permiso
            FROM sare_usuarios
            WHERE estado = 1 AND nombres LIKE '$dato %' OR nombres LIKE '% $dato'");
        if ($resultado == null) {
          $resultado = null;
          echo json_encode($resultado);
        } elseif($resultado != null) {
          //print_r($resultado);
          $c = count($resultado);
          for ($i = 0; $i < $c; $i++){
            switch ($resultado[$i]['PERMISO']){
              case 1:
                $resultado[$i]["PERMISO"] = "Superusuario";
                break;
              case 2:
                $resultado[$i]["PERMISO"] = "Administrativo";
                break;
              case 3:
                $resultado[$i]["PERMISO"] = "Profesor";
                break;
              case 4:
                $resultado[$i]["PERMISO"] = "Alumno";
                break;
            }
          }
          echo json_encode($resultado);
        }
        break;
        	
      case "por-ap":
        $dato = $_POST['apaterno'];
        $resultado = $this->bd->select("SELECT rut, nombres, apaterno, amaterno, username, email, permiso
            FROM sare_usuarios
            WHERE estado = 1 AND apaterno = '$dato'");
        if ($resultado == null) {
          $resultado = null;
          echo json_encode($resultado);
        } elseif($resultado != null) {
          //print_r($resultado);
          $c = count($resultado);
          for ($i = 0; $i < $c; $i++){
            switch ($resultado[$i]['PERMISO']){
              case 1:
                $resultado[$i]["PERMISO"] = "Superusuario";
                break;
              case 2:
                $resultado[$i]["PERMISO"] = "Administrativo";
                break;
              case 3:
                $resultado[$i]["PERMISO"] = "Profesor";
                break;
              case 4:
                $resultado[$i]["PERMISO"] = "Alumno";
                break;
            }
          }
          echo json_encode($resultado);
        }
        break;
        	
      case "por-am":
        $dato = $_POST['amaterno'];
        $resultado = $this->bd->select("SELECT rut, nombres, apaterno, amaterno, username, email, permiso
            FROM sare_usuarios
            WHERE estado = 1 AND amaterno = '$dato'");
        if ($resultado == null) {
          $resultado = null;
          echo json_encode($resultado);
        } elseif($resultado != null) {
          //print_r($resultado);
          $c = count($resultado);
          for ($i = 0; $i < $c; $i++){
            switch ($resultado[$i]['PERMISO']){
              case 1:
                $resultado[$i]["PERMISO"] = "Superusuario";
                break;
              case 2:
                $resultado[$i]["PERMISO"] = "Administrativo";
                break;
              case 3:
                $resultado[$i]["PERMISO"] = "Profesor";
                break;
              case 4:
                $resultado[$i]["PERMISO"] = "Alumno";
                break;
            }
          }
          echo json_encode($resultado);
        }
        break;
    }
  }

  public function ajaxCrear() {

    switch ($_POST['permiso']) {
      case "adm":
        $permiso = 2;
        break;
      case "prof":
        $permiso = 3;
        break;
      case "alum":
        $datosUsuario = array(
        'RUT' => (int)$_POST["rut"],
        'NOMBRES' => $_POST["nombres"],
        'APATERNO' => $_POST["ap-pat"],
        'AMATERNO' => $_POST["ap-mat"],
        'PERMISO' => 4,
        'USERNAME' => $_POST["usuario"],
        'PASSWD' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'EMAIL' => $_POST["email"]
        );
        $datosAlumno = array(
            'RUT' => (int)$_POST["rut"],
            'SEXO' => $_POST["sexo"],
            'DIRECCION' => $_POST["domicilio"]
        );
        $this->bd->insert('SARE_USUARIOS', $datosUsuario);
        echo "HOLAA";
        break;
    }
  }

  public function ajaxEditarGuardar() {

    $postData = array(
        'RUT' => (int)$_POST["rut"],
        'NOMBRES' => $_POST["nombres"],
        'APATERNO' => $_POST["ap-pat"],
        'AMATERNO' => $_POST["ap-mat"],
        'PERMISO' => (int)$_POST["permiso"],
        'USERNAME' => $_POST["username"],
        'PASSWD' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'EMAIL' => $_POST["email"]
    );
    //print_r($postData);
    $this->bd->update('SARE_USUARIOS', $postData, "RUT = {$_POST['rut']}");
  }

  public function ajaxDeshabilitar() {

    $postData = array('ESTADO' => 0);
    //print_r($postData);
    $this->bd->update('SARE_USUARIOS', $postData, "RUT = {$_POST['rut']}");

  }

  public function ajaxEliminar() {

    $id = (int)$_POST["rut"];
    $tabla = 'SARE_USUARIOS';
    $result = $this->bd->select('SELECT PERMISO FROM ' . $tabla . ' WHERE RUT = :id', array(':id' => $id));
    if ($result[0]['PERMISO'] == 1) return false;
    $this->bd->delete($tabla, "RUT = '$id'");
  }

  public function paCrearUsuario() {

    switch ($_POST["permiso"]) {
      	
      case "adm":
        $datosAdministrativo = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 2,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'estab' => $_POST["establecimiento"],
        'cargo' => $_POST["cargo"]
        );
        $this->bd->procAlmac('SP_USUARIO_ADM_INSERT', $datosAdministrativo);

        break;
        	
      case "prof":
        $datosProfesor = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 3,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'telefono' => $_POST["telefono"]
        );
        $this->bd->procAlmac('SP_USUARIO_PROF_INSERT', $datosProfesor);
        break;
        	
      case "alum":
        $datosAlumno = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 4,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'sexo' => $_POST["sexo"],
        'domicilio' => $_POST["domicilio"]
        );
        $this->bd->procAlmac('SP_USUARIO_ALUMNO_INSERT', $datosAlumno);
        break;
    }
  }

  public function paEditarUsuario() {

    switch ($_POST["permiso"]) {

      case "adm":
        $datosAdministrativo = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 2,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'estab' => $_POST["establecimiento"],
        'cargo' => $_POST["cargo"]
        );
        $this->bd->procAlmac('SP_USUARIO_ADM_UPDATE', $datosAdministrativo);
        break;
        	
      case "prof":
        $datosProfesor = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 3,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'telefono' => $_POST["telefono"]
        );
        $this->bd->procAlmac('SP_USUARIO_PROF_UPDATE', $datosProfesor);
        break;
        	
      case "alum":
        $datosAlumno = array(
        'rut' => (int)$_POST["rut"],
        'nombres' => $_POST["nombres"],
        'ap-pat' => $_POST["ap-pat"],
        'ap-mat' => $_POST["ap-mat"],
        'permiso' => 4,
        'usuario' => $_POST["usuario"],
        'password' => Hash::crear('sha256', $_POST["password"], HASH_PASSWORD_KEY),
        'email' => $_POST["email"],
        'estado' => 1,
        'sexo' => $_POST["sexo"],
        'domicilio' => $_POST["domicilio"]
        );
        $this->bd->procAlmac('SP_USUARIO_ALUMNO_UPDATE', $datosAlumno);
        break;
    }
  }
}