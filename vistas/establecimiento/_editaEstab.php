<div class="modal hide fade" id="modal-editar">
  <form id="form-editar-establecimiento" method="post"
    action="<?php echo URL;?>establecimiento/ajaxEditarGuardar">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">x</button>
      <h3>Editar Establecimiento</h3>
    </div>
    <div class="modal-body">
      <div style="float: left">
        <label>C&oacute;digo</label><input class="codigo-est"
          type="text" disabled="disabled" /><br /> <input
          class="codigo-est" type="hidden" name="codigo" /> <label>Nombre</label><input
          id="nombre-est" type="text" name="nombre"
          autofocus="autofocus" required="required" /><br /> <label>Direcci&oacute;n</label><input
          id="direccion-est" type="text" name="direccion"
          required="required" /><br />
      </div>
      <div style="float: right">
        <label>Regi&oacute;n</label><select id="region-est"
          name="region"></select><br /> <label>Provincia</label><select
          id="provincia-est" name="provincia"></select><br /> <label>Comuna</label><select
          id="comuna-est" name="comuna"></select><br />
      </div>
    </div>
    <div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal">Cancelar</a> <input
        id="editar" class="btn btn-primary" type="submit" />
    </div>
  </form>
</div>
