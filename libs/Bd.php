<?php

class Bd extends PDO {

  public function __construct($BD_USUARIO, $BD_PASS, $BD_HOST) {

    parent::__construct($BD_HOST, $BD_USUARIO, $BD_PASS);
  }

  public function pa($nombrePa, $datos) {

    try {
      	
    } catch (PDOException $e) {
      throw $e;
    }
  }

  /**
   * select
   * @param string $sql Un string SQL
   * @param array $array Parametros para bindValue()
   * @param constant $fetchMode Modo de extraccion de datos
   * @return mixed
   */
  public function select($sql, $array = array(), $modoFetch = PDO::FETCH_ASSOC) {

    try {
      $sth = $this->prepare($sql);
      foreach ($array as $key => $value) {
        $sth->bindValue("$key", $value);
      }
      $sth->execute();
      return $sth->fetchAll($modoFetch);
      	
    } catch(PDOException $e) {
      throw $e;
    }
  }

  /**
   * insert
   * @param string $tabla Nombre de la tabla donde se insertaran datos
   * @param string $datos Array con los datos a insertar
   */
  public function insert($tabla, $datos) {

    ksort($datos);
    $nombreCampos = implode(", ", array_keys($datos));
    $valorDatos = "'" . implode("', '", array_values($datos)) . "'";
    	
    try {
      $sql = $this->prepare("INSERT INTO $tabla ($nombreCampos) VALUES ($valorDatos)");
      $sql->execute();
      echo $sql;
      	
    } catch(PDOException $e) {
      throw $e;
    }
  }
  
  public function insertAll($datos) {

    $sentencia = implode(" ", array_values($datos)); 	
    try {
      $sql = $this->prepare("INSERT ALL $sentencia SELECT 1 FROM DUAL");
      $sql->execute();
      echo $sql;
      	
    } catch(PDOException $e) {
      throw $e;
    }
  }

  /**
   * procAlmac
   * @param string $nombrePa Nombre del procedimiento almacenado al cual se enviarán los datos
   * @param string $datos Array con los datos a insertar
   */
  public function procAlmac($nombrePa, $datos) {

    $valorDatos = "'" . implode("', '", array_values($datos)) . "'";

    try {
      $sql = $this->prepare("CALL $nombrePa($valorDatos)");
      $sql->execute();
      	
    } catch (PDOException $e) {
      throw $e;
    }

  }

  /**
   * update
   * @param string $tabla Nombre de la tabla donde se actualizarán los datos
   * @param string $datos Array con los datos a actualizar
   * @param string $where Condición de la sentencia sql
   */
  public function update($tabla, $datos, $where) {
    	
    ksort($datos);

    $fieldDetails = NULL;

    foreach($datos as $key=> $value) {
      $fieldDetails .= "$key=:$key,";
    }
    $fieldDetails = rtrim($fieldDetails, ',');

    try {
      $sql = $this->prepare("UPDATE $tabla SET $fieldDetails WHERE $where");

      foreach ($datos as $key => $value) {
        $sql->bindValue(":$key", $value);
      }
      $sql->execute();
      	
    } catch(PDOException $e) {
      throw $e;
    }

  }

  /**
   * deshabilitar
   * @param string $tabla Nombre de la tabla donde se actualizarán los datos
   * @param string $datos Array con los datos a actualizar
   * @param string $where Condición de la sentencia sql
   */
  public function deshabilitar($tabla, $datos, $where) {
    	
    ksort($datos);

    $fieldDetails = NULL;

    foreach($datos as $key=> $value) {
      $fieldDetails .= "$key=:$key,";
    }
    $fieldDetails = rtrim($fieldDetails, ',');

    try {
      $sql = $this->prepare("UPDATE $tabla SET $fieldDetails WHERE $where");

      foreach ($datos as $key => $value) {
        $sql->bindValue(":$key", $value);
      }
      $sql->execute();
      	
    } catch(PDOException $e) {
      throw $e;
    }

  }

  /**
   * delete
   * @param string $tabla Nombre de la tabla donde se borrarán los datos
   * @param string $where Condición de la sentencia sql
   * @return integer Filas Afectadas
   */
  public function delete($tabla, $where) {

    return $this->exec("DELETE FROM $tabla WHERE $where");
  }

}