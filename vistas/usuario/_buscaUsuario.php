<h3>Buscar usuario por <?php echo $this->formBuscar[0]; ?></h3>
<form id="form-buscar-usuario" method="post" action="<?php echo URL;?>usuario/buscarUsuario">
  <label>Ingrese <?php echo $this->formBuscar[0]; ?></label>
  <input id="buscador-usuario" type="<?php echo $this->formBuscar[2]; ?>" name="<?php echo $this->formBuscar[4]; ?>" autofocus="autofocus" required="required" />
  <input type="hidden" value="<?php echo $this->formBuscar[3]; ?>" name="tipo" />
  <input id="<?php echo $this->formBuscar[1]; ?>" class="btn btn-primary" type="submit" value="Buscar" />
</form>
<div id="cont-resultado-busqueda" style="display: none;">
  <table id="tabla-resultado-busqueda" class="table table-striped">
    <tr style="font-weight:bolder">
	  <td>RUT</td>
	  <td>Nombres</td>
	  <td>Apellido Paterno</td>
	  <td>Apellido Materno</td>
	  <td>Nombre Usuario</td>
	  <td>eMail</td>
	  <td>Tipo Usuario</td>
    </tr>
  </table>
</div>
<div id="cont-resultado-ninguno" style="display: none;"></div>