<div class="hero-unit" style="overflow: hidden;">
  <h2>M&oacute;dulo Establecimientos</h2>
  <div>
    <a id="agregar-estab" class="boton btn btn-success" href="#">Agregar nuevo establecimiento</a>
    <a id="listar-estab" class="boton btn btn-warning" href="#">Listar establecimientos</a>
  </div>

  <div id="cont-festablecimientos" class="cont-form seccion" style="display:none"></div>
  <div id="cont-listaestablecimientos" class="seccion" style="display:none"></div>
  <div id="cont-editar"></div>
  
  <div class="modal hide fade" id="modal-eliminar">
  	<div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Eliminar Establecimiento</h3>
  	</div>
  	<div class="modal-body">
	  <p>&#191;Est&aacute; seguro que quiere eliminar el establecimiento <span id="establecimiento-eliminar"></span>?</p>
  	</div>
  	<div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a>
      <a href="#" id="eliminar" class="btn btn-primary" data-dismiss="modal">Eliminar</a>
    </div>
  </div>
</div>

