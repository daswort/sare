<h3>Crear Profesor</h3>
<div id="alerta-creacion" class="alert alert-success fade in hide">
  <button type="button" class="close" data-dismiss="alert">x</button>
  <span>&iexcl;<strong>Profesor</strong> creado!</span>
</div>
<form id="fusuarios" method="post" action="<?php echo URL;?>usuario/paCrearUsuario">
  <div style="float: left;">
    <label>RUT</label><input class="inputusuario" type="text" name="rut"  autofocus="autofocus" required="required" /><br />
    <label>Nombres</label><input class="inputusuario" type="text" name="nombres" required="required" /><br />
    <label>Apellido Paterno</label><input class="inputusuario" type="text" name="ap-pat" required="required" /><br />
    <label>Apellido Materno</label><input class="inputusuario" type="text" name="ap-mat" required="required" /><br />
  </div>
  <div style="float: right;">
  	<input type="hidden" value="prof" name="permiso">
	<label>Tel&eacute;fono</label><input class="inputusuario" type="text" name="telefono" required="required"><br />
    <label>Nombre Usuario</label><input class="inputusuario" type="text" name="usuario" required="required" /><br />
    <label>Email</label><input class="inputusuario" type="email" name="email" /><br />
    <label>Contrase&ntilde;a</label><input class="inputusuario" type="password" name="password" required="required" /><br />
    <label>&nbsp;</label><input class="boton btn btn-primary btn-submit-form" type="submit" />
  </div>
</form>