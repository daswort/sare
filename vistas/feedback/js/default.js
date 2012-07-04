$(function() {
	$.get('feedback/selectCursos', { 'nivel': 'b' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-basica').append('<option value="' + o[i].GRADO + o[i].LETRA + o[i].NIVEL + '">' + o[i].GRADO + '&#176; B&aacute;sico ' + o[i].LETRA.toUpperCase() + '</option>');
		}
	}, 'json');
	$.get('feedback/selectCursos', { 'nivel': 'm' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-media').append('<option value="' + o[i].GRADO + '-' + o[i].LETRA + '-' + o[i].NIVEL + '">' + o[i].GRADO + '&#176; Medio ' + o[i].LETRA.toUpperCase() + '</option>');
		}
	}, 'json');
	
	$('#r-basica:checked').live('click', function (){
		$('#cont-selec-cursos-basica').fadeIn('slow');
		$('#cont-selec-asignturas-basica').fadeIn('slow');
		$('#cont-selec-cursos-media').attr('style','display:none');
		$('#cont-selec-asignturas-media').attr('style','display:none');
	});
	$('#select-cursos-basica').live('change', function (){
		$('.op-asig-b').remove();
		var grado = $(this).val().substr(0,1);
		$.get('feedback/selectAsignaturas', { 'nivel': 'b', 'grado': grado } , function (o){
			for (var i = 0; i < o.length; i++){			
				$('#select-asignaturas-basica').append('<option class="op-asig-b" value="' + o[i].CODIGO + '">' + o[i].NOMBRE + '</option>');
			}
		}, 'json');
	});
	
	$('#r-media:checked').live('click', function (){
		$('#cont-selec-cursos-basica').attr('style','display:none');
		$('#cont-selec-asignturas-basica').attr('style','display:none');
		$('#cont-selec-cursos-media').fadeIn('slow');
		$('#cont-selec-asignturas-media').fadeIn('slow');
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
});