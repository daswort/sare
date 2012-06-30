<div class="modal hide fade" id="modal-editar">
  <form id="form-editar-alumno" method="post" action="<?php echo URL;?>usuario/paEditarUsuario">
  	<div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Editar Alumno</h3>
  	</div>
  	<div class="modal-body">
  	  <div style="float: left;">
        <label>RUT</label><input class="inputusuario rut-alum" type="text" disabled="disabled" /><br />
        <input class="rut-alum" type="hidden" name="rut">
        <label>Nombres</label><input id="nombres-alum" class="inputusuario" type="text" name="nombres" autofocus="autofocus" required="required" /><br />
        <label>Apellido Paterno</label><input id="apaterno-alum" class="inputusuario" type="text" name="ap-pat" required="required" /><br />
        <label>Apellido Materno</label><input id="amaterno-alum" class="inputusuario" type="text" name="ap-mat" required="required" /><br />
        <label>Sexo</label><span style="margin-right:60px;"><input class="inputusuario" type="radio" name="sexo" value="f"> Femenino</span> <span><input class="inputusuario" type="radio" name="sexo" value="m"> Masculino</span><br />
      </div>
      <div style="float: right;">
    	<input type="hidden" value="alum" name="permiso">
    	<label>Domicilio</label><input id="domicilio-alum" class="inputusuario" type="text" name="domicilio" required="required"><br />
    	<label>Nombre Usuario</label><input id="username-alum" class="inputusuario" type="text" name="usuario" required="required" /><br />
    	<label>Email</label><input id="email-alum" class="inputusuario" type="email" name="email" /><br />
    	<label>Contrase&ntilde;a</label><input id="password-alum" class="inputusuario" type="password" name="password" required="required" /><br />
  	  </div>  	
  	</div>
  	<div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a>
      <input id="editar" class="btn btn-primary" type="submit" />
    </div>
  </form>    
</div>