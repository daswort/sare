$(function() {
	$.get('usuario/ajaxListaUsuarios', { 'permiso': 'prof' }, function(o) {
		for(var i = 0; i < o.length; i++ ){
			$('#select-prof').append('<option value="' + o[i].RUT + '">' + o[i].NOMBRES + ' ' + o[i].APATERNO + '</option>');
		}
	}, 'json');
	$.get('clase/selectCursos', { 'nivel': 'b' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-basica').append('<option value="' + o[i].GRADO + o[i].LETRA + o[i].NIVEL + '">' + o[i].GRADO + '&#176; B&aacute;sico ' + o[i].LETRA.toUpperCase() + '</option>');
		}
	}, 'json');
	$.get('clase/selectCursos', { 'nivel': 'm' } , function (o){
		for (var i = 0; i < o.length; i++){			
			$('#select-cursos-media').append('<option value="' + o[i].GRADO + o[i].LETRA + o[i].NIVEL + '">' + o[i].GRADO + '&#176; Medio ' + o[i].LETRA.toUpperCase() + '</option>');
		}
	}, 'json');
	$('#select-prof').change(function(){
		$('#verifica-profe').removeAttr('checked');
	});
	$('#verifica-profe:checked').live('click', function(){
		var rutProf = $('#select-prof').val();
		$.get('clase/verificaProfJefe',{ 'rut-profesor': rutProf  }, function (o){
			if (jQuery.isEmptyObject(o) == false) {
				$("#resp-verifica").animate({ 'height':'toggle','opacity':'toggle'});
				window.setTimeout( function(){
					$("#resp-verifica").slideUp();
				}, 3500);
				$('#verifica-profe').removeAttr('checked');
			}
		}, 'json');
	});
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
		$.get('clase/selectAsignaturas', { 'nivel': 'b', 'grado': grado } , function (o){
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
		$.get('clase/selectAsignaturas', { 'nivel': 'm', 'grado': grado } , function (o){
			for (var i = 0; i < o.length; i++){			
				$('#select-asignaturas-media').append('<option class="op-asig-m" value="' + o[i].CODIGO + '">' + o[i].NOMBRE + '</option>');
			}
		}, 'json');
	});
	$('#form-clases').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	$("#alerta-creacion").animate({ 'height':'toggle','opacity':'toggle'});
            window.setTimeout( function(){
                $("#alerta-creacion").slideUp();
            }, 2500);
        }, 'json');
		$('#verifica-profe').removeAttr('checked');
        $('.inputusuario').val("");
		$('.option-default').attr('selected','selected');
        return false;
    });
});