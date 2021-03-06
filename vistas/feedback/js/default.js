$(function() {
	$.get('feedback/selectCursos', { 'nivel': 'b' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-basica').append('<option value="' + o[i].GRADO_CURSO + o[i].LETRA_CURSO + o[i].NIVEL_CURSO + '">' + o[i].GRADO_CURSO + '&#176; B&aacute;sico ' + o[i].LETRA_CURSO.toUpperCase() + '</option>');
		}
	}, 'json');
	$.get('feedback/selectCursos', { 'nivel': 'm' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-media').append('<option value="' + o[i].GRADO + o[i].LETRA + o[i].NIVEL + '">' + o[i].GRADO + '&#176; Medio ' + o[i].LETRA.toUpperCase() + '</option>');
		}
	}, 'json');
	
	$('#r-basica:checked').live('click', function (){
		$('.option-default').attr('selected','selected');
		$('#select-cursos-basica').removeAttr('disabled');
		$('#select-asignaturas-basica').removeAttr('disabled');
		$('#select-cursos-media').attr('disabled','disabled');
		$('#select-asignaturas-media').attr('disabled','disabled');
		$('#cont-select-cursos-basica').fadeIn('slow');
		$('#cont-select-asignaturas-basica').fadeIn('slow');
		$('#cont-select-cursos-media').attr('style','display:none');
		$('#cont-select-asignaturas-media').attr('style','display:none');
	});
	$('#select-cursos-basica').live('change', function (){
		$('.op-asig-b').remove();
		var grado = $(this).val().substr(0,1);
		var letra = $(this).val().substr(1,1);
		$.get('feedback/selectAsignaturas', { 'nivel': 'b', 'grado': grado, 'letra': letra } , function (o){
			for (var i = 0; i < o.length; i++){			
				$('#select-asignaturas-basica').append('<option class="op-asig-b" value="' + o[i].CODIGO + '">' + o[i].NOMBRE + '</option>');
			}
		}, 'json');
	});
	
	$('#r-media:checked').live('click', function (){
		$('.option-default').attr('selected','selected');
		$('#select-cursos-media').removeAttr('disabled');
		$('#select-asignaturas-media').removeAttr('disabled');
		$('#select-cursos-basica').attr('disabled','disabled');
		$('#select-asignaturas-basica').attr('disabled','disabled');
		$('#cont-select-cursos-basica').attr('style','display:none');
		$('#cont-select-asignaturas-basica').attr('style','display:none');
		$('#cont-select-cursos-media').fadeIn('slow');
		$('#cont-select-asignaturas-media').fadeIn('slow');
	});
	$('#select-cursos-media').live('change', function (){
		$('.op-asig-m').remove();
		var grado = $(this).val().substr(0,1);
		$.get('feedback/selectAsignaturas', { 'nivel': 'm', 'grado': grado } , function (o){
			for (var i = 0; i < o.length; i++){			
				$('#select-asignaturas-media').append('<option class="op-asig-m" value="' + o[i].CODIGO + '">' + o[i].NOMBRE + '</option>');
			}
		}, 'json');
	});
	
	var bar = $('.bar');
    var percent = $('.percent');
    var status = $('#status');

    $('#form-feedback').ajaxForm({
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