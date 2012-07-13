<p>Reportes Cursos Ense&ntilde;anza Media</p>
<form id="form-reporte" method="post" action="<?php echo URL;?>reporte/generarReportePdf">
  <label>Indique un curso</label>
  <select id="select-por-curso-media" name="curso">
    <option class="option-default">Seleccione un curso</option>
  </select>
  <input class="btn btn-primary" type="submit" value="Generar Reporte" />
</form>