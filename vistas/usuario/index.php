<div class="hero-unit" style="overflow:hidden;">
  <h2>M&oacute;dulo Usuario</h2>

  <div style="display: inline-block;">
  <div class="btn-group btn-menu-usu">
    <a class="boton btn btn-success" href="#" style="margin-right:0px; margin-bottom:0px;">Ingresar Usuario</a>
    <a class="boton btn btn-success dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
    <ul class="dropdown-menu">
    <?php if (Sesion::get('rol') == 1): ?>
      <li><a id="agregar-administrativo" href="#"><i class="icon-briefcase"></i> Administrativo</a></li>
      <li><a id="agregar-profesor" href="#"><i class="icon-book"></i> Profesor</a></li>
      <li><a id="agregar-alumno" href="#"><i class="icon-pencil"></i> Alumno</a></li>
    <?php endif ?>
    <?php if (Sesion::get('rol') == 2): ?>
      <li><a id="agregar-profesor" href="#"><i class="icon-book"></i> Profesor</a></li>
      <li><a id="agregar-alumno" href="#"><i class="icon-pencil"></i> Alumno</a></li>
    <?php endif ?>
    </ul>
  </div>
  <div class="btn-group btn-menu-usu">
    <a class="boton btn btn-warning" href="#" style="margin-right:0px; margin-bottom:0px;">Listar Usuarios</a>
    <a class="boton btn btn-warning dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
    <ul class="dropdown-menu">
    <?php if (Sesion::get('rol') == 1): ?>
      <li><a id="listar-administrativo" href="#"><i class="icon-briefcase"></i> Administrativos</a></li>
      <li><a id="listar-profesor" href="#"><i class="icon-book"></i> Profesores</a></li>
      <li><a id="listar-alumno" href="#"><i class="icon-pencil"></i> Alumnos</a></li>
    <?php endif ?>
    <?php if (Sesion::get('rol') == 2): ?>
      <li><a id="listar-profesor" href="#"><i class="icon-book"></i> Profesores</a></li>
      <li><a id="listar-alumno" href="#"><i class="icon-pencil"></i> Alumnos</a></li>
    <?php endif ?>
    </ul>
  </div>
  </div>
  
  <div id="cont-fusuarios" class="cont-form seccion"></div>
  <div id="cont-listausuarios" class="seccion" style="display:none"></div>
  <div id="cont-editar"></div>
  
  <div class="modal hide fade" id="modal-eliminar">
  	<div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Eliminar Usuario</h3>
  	</div>
  	<div class="modal-body">
	  <p>&#191;Est&aacute; seguro que quiere eliminar a <span id="usuario-eliminar"></span>?</p>
  	</div>
  	<div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a>
      <a href="#" id="eliminar" class="btn btn-primary" data-dismiss="modal">Eliminar</a>
    </div>
  </div>
</div>