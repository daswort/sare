<div id="alerta-creacion" class="alert alert-success fade in hide">
  <button type="button" class="close" data-dismiss="alert">x</button>
  <span>&iexcl;<strong>Establecimiento</strong> creado!</span>
</div>
<form id="festablecimientos" method="post" action="<?php echo URL;?>establecimiento/ajaxCrear">
  <div style="float: left;">
    <label>C&oacute;digo</label><input class="inputestablecimiento" type="text" name="codigo" autofocus = "autofocus" required = "required" /><br />
    <label>Nombre</label><input class="inputestablecimiento" type="text" name="nombre" required = "required" /><br />
    <label>Direcci&oacute;n</label><input class="inputestablecimiento" type="text" name="direccion" required = "required" /><br />
  </div>
  <div style="float: right;">
	<label>Regi&oacute;n</label>
	<select id="select-regiones-cr" class="inputestablecimiento" name="region">
      <option value="0">Seleccione una regi&oacute;n</option>
    </select>	
    <label>Provincia</label>
	<select id="select-provincias-cr" class="inputestablecimiento" name="provincia" disabled="disabled">
      <option value="0">Seleccione una provincia</option>
    </select>	
    <label>Comuna</label>
	  <select id="select-comunas-cr" class="inputestablecimiento" name="comuna" disabled="disabled">
        <option value="0">Seleccione una comuna</option>
	  </select>
	<label>&nbsp;</label><input class="boton btn btn-primary btn-submit-form" type="submit" />
  </div>
</form>