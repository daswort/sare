<div class="hero-unit" style="overflow: hidden;">
  <h2>M&oacute;dulo Clases</h2>
  
  <div id="cont-form-clases" class="cont-form seccion">
	<h3>Crear Clase</h3>
    <div id="alerta-creacion" class="alert alert-success fade in hide">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <span>&iexcl;<strong>Clase</strong> creada!</span>
    </div>
    <form id="form-clases" method="post" action="<?php echo URL; ?>clase/crearClase">
	  <div style="float:left">
	    <label>Seleccione Profesor</label>
		<select id="select-prof" name="profesor" required="required">
		  <option class="option-default" value="0">Seleccione un profesor</option>
		</select><br />
		<label>Profesor Jefe?</label><div id="resp-verifica" style="display:none">El profesor seleccionado ya es profesor jefe.</div>
		<input id="verifica-profe" name="es-profe-jefe" type="checkbox" value="prof-jefe"><br />
		<label>A&ntilde;o</label>
		<input name="anio" type="number" value="<?php echo strftime("%Y", time()); ?>">
	  </div>
	  <div style="float:right">
	    <label>Curso</label>
        <span style="margin-right: 30px;">B&aacute;sico<input id="r-basica" type="radio" name="nivel" value="b" checked="checked" /></span>
        <span> Medio<input id="r-media" type="radio" name="nivel" value="m" /></span>
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
		<input class="boton btn btn-primary btn-submit-form" type="submit" value="Enviar" />
	  </div>
	</form>
  </div>
</div>