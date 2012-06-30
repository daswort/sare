<div class="modal hide fade" id="modal-editar">
  <form id="form-editar" method="post" action="<?php echo URL;?>establecimiento/ajaxEditarGuardar">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal">x</button>
    <h3>Editar Establecimiento</h3>
  </div>
    <div class="input-editar" style="float:left">
  <label>C&oacute;digo</label><input id="codigo-est" type="text" name="codigo" required = "required" disabled="disabled" /><br />
  <label>Nombre</label><input id="nombre-est" type="text" name="nombre"  autofocus="autofocus" required="required" /><br />
  <label>Direcci&oacute;n</label><input id="direccion-est" type="text" name="direccion" required="required" /><br />
</div>
<div class="input-editar" style="float:right">
  <label>Regi&oacute;n</label>
  <select id="select-regiones-ed" class="inputestablecimiento" name="region">
    <option></option>
  </select><br />
  <label>Provincia</label>
  <select id="select-provincias-ed" class="inputestablecimiento" name="provincia" disabled="disabled">
    <option></option>
  </select><br />
  <label>Comuna</label>
  <select id="select-comunas-ed" class="inputestablecimiento" name="comuna" disabled="disabled">
    <option></option>
  </select><br />
  <label>&nbsp;</label><input class="btn btn-primary btn-submit-form" type="submit" />
</div>
	