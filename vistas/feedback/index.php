<div class="hero-unit" style="overflow:hidden;">
  <h2>M&oacute;dulo Feedback</h2>
  
  <div id="cont-form-feedback" class="cont-form seccion">
    <form id="form-feedback" method="post" action="<?php echo URL; ?>feedback/procesarExcel" enctype="multipart/form-data">
      <div style="float: left">
        <label>Cargar Excel</label>
        <div id="cont-arch-feedback">
          <input id="arch-feedback" class="input-file" type="file" name="fichero" size="40" ><br />
        </div>
<!--         <label>Curso</label> -->
<!--        <span style="margin-right:30px;">B&aacute;sico <input id="r-basica" type="radio" name="nivel" value="b" checked="checked" /></span>
<!--         <span> Medio<input id="r-media" type="radio" name="nivel" value="m" /></span> -->
<!--         <div id="cont-selec-cursos-basica"> -->
<!--           <label>Cursos Ense&ntilde;anza B&aacute;sica</label> -->
<!--           <select id="select-cursos-basica" name="curso" > -->
<!--             <option value="0">Seleccione un curso</option> -->
<!--           </select> -->
<!--         </div> -->
<!--        <div id="cont-selec-cursos-media" style="display:none;">
<!--           <label>Cursos Ense&ntilde;anza Media</label> -->
<!--           <select id="select-cursos-media" name="curso" > -->
<!--             <option value="0">Seleccione un curso</option> -->
<!--           </select> -->
<!--         </div> -->
<!--         <div id="cont-selec-asignturas-basica"> -->
<!--            <label>Asignaturas Ense&ntilde;anza B&aacute;sica</label> -->
<!--           <select id="select-asignaturas-basica" name="asignatura"> -->
<!--             <option value="0">Seleccione una asignatura</option> -->
<!--           </select> -->
<!--         </div> -->
<!--        <div id="cont-selec-asignturas-media" style="display:none;"> -->
<!--            <label>Asignaturas Ense&ntilde;anza Media</label> -->
<!--           <select id="select-asignaturas-media" name="asignatura"> -->
<!--             <option value="0">Seleccione una asignatura</option> -->
<!--           </select> -->
<!--         </div> -->
        
      </div>
      <div style="float: right">
        <input type="submit" value="Enviar" />
      </div>
    </form>
  </div>
</div>