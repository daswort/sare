<div class="modal hide fade" id="modal-editar">
  <form id="form-editar-administrativo" method="post" action="<?php echo URL;?>usuario/paEditarUsuario">
  	<div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Editar Administrativo</h3>
  	</div>
  	<div class="modal-body">
  	  <div style="float: left;">
        <label>RUT</label><input class="inputusuario rut-adm" type="text" disabled="disabled" /><input class="rut-adm" type="hidden" name="rut"><br />
        <label>Nombres</label><input id="nombres-adm" class="inputusuario" type="text" name="nombres" autofocus="autofocus" required="required" /><br />
        <label>Apellido Paterno</label><input id="apaterno-adm" class="inputusuario" type="text" name="ap-pat" required="required" /><br />
        <label>Apellido Materno</label><input id="amaterno-adm" class="inputusuario" type="text" name="ap-mat" required="required" /><br />
      	<label>Establecimiento</label><select id="estab-adm" name="establecimiento"></select>
      </div>
      <div style="float: right;">
    	<input type="hidden" value="adm" name="permiso">
    	<label>Cargo</label><input id="cargo-adm" class="inputusuario" type="text" name="cargo" required="required"><br />
    	<label>Nombre Usuario</label><input id="username-adm" class="inputusuario" type="text" name="usuario" required="required" /><br />
    	<label>Email</label><input id="email-adm" class="inputusuario" type="email" name="email" required="required" /><br />
    	<label>Contrase&ntilde;a</label><input id="password-adm" class="inputusuario" type="password" name="password" required="required" /><br />
  	  </div>  	
  	</div>
  	<div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a>
      <input id="editar" class="btn btn-primary" type="submit" />
    </div>
  </form>    
</div>