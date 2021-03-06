<div class="hero-unit" style="overflow: hidden;">
  <h2>M&oacute;dulo Feedback</h2>

  <div id="cont-form-feedback" class="seccion">
    <form id="form-feedback" method="post" action="<?php echo URL; ?>feedback/procesarExcel" enctype="multipart/form-data">
      <div style="float: left">
        <label>Cargar Excel</label>
        <div id="cont-arch-feedback">
          <input id="arch-feedback" class="input-file" type="file" name="fichero" size="40" required="required">
          <div class="progress">
            <div class="bar"></div>
            <div class="percent">0%</div>
          </div>
		</div><br />
        <label>Curso</label>
        <span style="margin-right: 30px;">B&aacute;sico<input id="r-basica" type="radio" name="nivel" value="b" checked="checked" /></span>
        <span> Medio<input id="r-media" type="radio" name="nivel" value="m" /></span>
	  </div>
      <div style="float: right">
		<div id="cont-select-cursos-basica">
          <label>Cursos Ense&ntilde;anza B&aacute;sica</label>
          <select id="select-cursos-basica" name="curso">
            <option class="option-default" value="0">Seleccione un curso</option>
          </select>
        </div>
        <div id="cont-select-cursos-media" style="display: none;">
          <label>Cursos Ense&ntilde;anza Media</label>
          <select id="select-cursos-media" name="curso" disabled="disabled">
            <option class="option-default" value="0">Seleccione un curso</option>
          </select>
        </div>
        <div id="cont-select-asignaturas-basica">
          <label>Asignaturas Ense&ntilde;anza B&aacute;sica</label>
          <select id="select-asignaturas-basica" name="asignatura">
            <option class="option-default" value="0">Seleccione una asignatura</option>
          </select>
        </div>
        <div id="cont-select-asignaturas-media" style="display: none;">
          <label>Asignaturas Ense&ntilde;anza Media</label>
          <select id="select-asignaturas-media" name="asignatura" disabled="disabled">
            <option class="option-default" value="0">Seleccione una asignatura</option>
          </select>
        </div>
		<label>Fecha Evaluacion</label>
		<input type="date" name="fecha-eval" required="required" /><br />
		<div>
          <input class="boton btn btn-primary btn-submit-form" type="submit" value="Enviar" />
		</div>
	  </div>
    </form>
    <div id="status"></div>
  </div>
</div>
