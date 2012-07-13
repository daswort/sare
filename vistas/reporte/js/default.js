$(function() {
	$('.link-reporte-asig').live('click', function(){
		var tipo = $(this).attr('href');
		$.get('reporte/muestraForm', { 'opcion': tipo }, function(o){
			$('#cont-form-reporte').html(o);
			$.get('reporte/listaCursos', { 'opcion': 'b' }, function(o){
				for (var i = 0; i < o.length; i++){			
					$('#select-por-curso-basica').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
				}
			}, 'json');
			$.get('reporte/listaCursos', { 'opcion': 'm' }, function(o){
				for (var i = 0; i < o.length; i++){			
					$('#select-por-curso-media').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
				}
			}, 'json');
		});
	});
	$('.link-reporte-alum').live('click', function(){
		var tipo = $(this).attr('href');
		$.get('reporte/muestraForm', { 'opcion': tipo }, function(o){
			$('#cont-form-reporte').html(o);
			$.get('reporte/listaCursos', { 'opcion': 'b' }, function(o){
				for (var i = 0; i < o.length; i++){			
					$('#select-por-curso-basica').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
				}
				$('#select-por-curso-basica').change(function(){
					var curso = $(this).val();
					$.get('reporte/listaAlumnos', { 'curso': curso }, function(o){
						//$('#select-alum-basica').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
					}, 'json');
				});
			}, 'json');
			$.get('reporte/listaCursos', { 'opcion': 'm' }, function(o){
				for (var i = 0; i < o.length; i++){			
					$('#select-por-curso-media').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
				}
			}, 'json');
		});
	});
	$('#generar').click(function(){
		var dato = $('#input-datos').val();
		$.post('reporte/generarReportePdf', { 'dato': dato }, function(){
			/* =D */
		});
	});
	var bar = $('.bar');
    var percent = $('.percent');
    var status = $('#status');

    $('#form-reporte').ajaxForm({
        beforeSend: function () {
            status.empty();
            var percentVal = '0%';
            bar.width(percentVal)
            percent.html(percentVal);
        },
        uploadProgress: function (event, position, total, percentComplete) {
            var percentVal = percentComplete + '%';
            bar.width(percentVal)
            percent.html(percentVal);
            //console.log(percentVal, position, total);
        },
        complete: function (xhr) {
            status.html(xhr.responseText);
        }
    });
});