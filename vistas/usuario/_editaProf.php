<div class="modal hide fade" id="modal-editar">
  <form id="form-editar-profesor" method="post"
    action="<?php echo URL;?>usuario/paEditarUsuario">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Editar Profesor</h3>
    </div>
    <div class="modal-body">
      <div style="float: left;">
        <label>RUT</label><input class="inputusuario rut-prof"
          type="text" disabled="disabled" /><br /> <input
          class="rut-prof" type="hidden" name="rut"> <label>Nombres</label><input
          id="nombres-prof" class="inputusuario" type="text"
          name="nombres" autofocus="autofocus" required="required" /><br />
        <label>Apellido Paterno</label><input id="apaterno-prof"
          class="inputusuario" type="text" name="ap-pat"
          required="required" /><br /> <label>Apellido Materno</label><input
          id="amaterno-prof" class="inputusuario" type="text"
          name="ap-mat" required="required" /><br />
      </div>
      <div style="float: right;">
        <input type="hidden" value="prof" name="permiso"> <label>Tel&eacute;fono</label><input
          id="telefono-prof" class="inputusuario" type="text"
          name="telefono" required="required"><br /> <label>Nombre
          Usuario</label><input id="username-prof" class="inputusuario"
          type="text" name="usuario" required="required" /><br /> <label>Email</label><input
          id="email-prof" class="inputusuario" type="email" name="email" /><br />
        <label>Contrase&ntilde;a</label><input id="password-prof"
          class="inputusuario" type="password" name="password"
          required="required" /><br />
      </div>
    </div>
    <div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a> <input
        id="editar" class="btn btn-primary" type="submit" />
    </div>
  </form>
</div>
