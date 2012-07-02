/*
** Autor: Jacob Vidal.
*/

$(function () {
    
    $('#agregar-administrativo').click(function () {
        $('#cont-listausuarios').fadeOut("slow");
        $('#cont-buscar').fadeOut("slow");
        $('#cont-fusuarios').fadeIn("slow");
        $.get('usuario/muestraForm', { 'id': 2 }, function (o){
        	$('#cont-fusuarios').html(o);
        });
        $.get('establecimiento/ajaxListaEstablecimientos', function (o){
    		for (var i = 0; i < o.length; i++) {
    			$('#lista-estab').append('<option value="' + o[i].CODIGO + '">' + o[i].NOMBRE + '</option>');
    		}
    	}, 'json');
    });
    
    $('#agregar-profesor').click(function () {
        $('#cont-listausuarios').fadeOut("slow");
        $('#cont-buscar').fadeOut("slow");
        $('#cont-fusuarios').fadeIn("slow");
        $.get('usuario/muestraForm', { 'id': 3 }, function (o){
        	$('#cont-fusuarios').html(o);
        });
    });
    
    $('#agregar-alumno').click(function () {
        $('#cont-listausuarios').fadeOut("slow");
        $('#cont-buscar').fadeOut("slow");
        $('#cont-fusuarios').fadeIn("slow");
        $.get('usuario/muestraForm', { 'id': 4 }, function (o){
        	$('#cont-fusuarios').html(o);
        });
    });
    
    $('#fusuarios').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	$("#alerta-creacion").animate({ 'height':'toggle','opacity':'toggle'});
            window.setTimeout( function(){
                $("#alerta-creacion").slideUp();
            }, 2500);
        }, 'json');
        $('.inputusuario').val("");
        return false;
    });
    
    $('#listar-administrativo').click(function () {
    	$('#cont-fusuarios').fadeOut("slow");
    	$('#cont-buscar').fadeOut("slow");
    	$('#cont-listausuarios').fadeIn("slow");
    	$.get('usuario/muestraEditar', { 'id': 2 }, function (o){
        	$('#cont-editar').html(o);
		});
    	$.get('usuario/muestraLista', { 'id': 2 }, function (o){
        	$('#cont-listausuarios').html(o);
        	$.get('usuario/ajaxListaUsuarios', { 'permiso': 'adm' }, function (o){
        		for (var i = 0; i < o.length; i++) {
        			if (o[i].PERMISO == 1){
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><<td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td></tr>');
        			} else {
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><td>' + o[i].CARGO + '</td><td>' + o[i].NOMBRE + '</td><td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td><td><a href="#" class="del" name="' + o[i].NOMBRES + '" rel="' + o[i].RUT + '">Eliminar</a></td></tr>');
        			}
        		}
        	}, 'json');
        	$('.editar').live('click', function () {
        		var id = $(this).attr('rel');
                $.post('usuario/ajaxListaUnUsuario', { 'id': id, 'permiso': 'adm' }, function (o) {
                	$('#estab-adm option').remove();
                	$('.rut-adm').attr('value', o[0].RUT);
                	$('#nombres-adm').attr('value', o[0].NOMBRES);
                	$('#apaterno-adm').attr('value', o[0].APATERNO);
                	$('#amaterno-adm').attr('value', o[0].AMATERNO);
                	var codEst = o[0].CODIGO;
                	$.get('establecimiento/ajaxListaEstablecimientos', function (a){
                		for (var i = 0; i < a.length; i++) {
                			if(a[i].CODIGO != codEst){
                				$('#estab-adm').append('<option value="' + a[i].CODIGO + '">' + a[i].NOMBRE + '</option>');
                			} else {
                				$('#estab-adm').append('<option selected="selected" value="' + a[i].CODIGO + '">' + a[i].NOMBRE + '</option>');
                			}
                		}
                	}, 'json');
                	//$('#estab-adm option').attr('value', o[0].CODIGO);
                	$('#cargo-adm').attr('value', o[0].CARGO);
                	$('#username-adm').attr('value', o[0].USERNAME);
                	$('#password-adm').attr('value', o[0].PASSWD);
                	$('#email-adm').attr('value', o[0].EMAIL);
                	$('#modal-editar').modal();
                }, 'json');
        	});
        	$('#form-editar-administrativo').live('submit', function () {
                var url = $(this).attr('action');
                var data = $(this).serialize();
                $.post(url, data, function (o) {
                	/**:P**/
                }, 'json');
                $('.inputusuario').val("");
                $("#alerta-editar-adm").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-editar-adm").slideUp();
                }, 2500);
                $('#modal-editar').modal('hide');
                return false;
            });
        	$('.del').live('click', function () {
        		var id = $(this).attr('rel');
        		$('#usuario-eliminar strong').remove();
        		var nombre = $(this).attr('name');
				$('#usuario-eliminar').append('<strong>' + nombre + '</strong>');
				$('#eliminar').attr('rel', id);
        		$('#modal-eliminar').modal();
			});
        	$('#eliminar').click( function () {
        		var id = $(this).attr('rel');
        		var delItem = $('#fila-' + id);
				$.post('usuario/ajaxDeshabilitar', {
					'rut': id
				}, function (o) {
					delItem.remove();
				}, 'json');
				$("#alerta-eliminar-adm").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-eliminar-adm").slideUp();
                }, 2500);
    		});
        });
    });
    
    $('#listar-profesor').click(function () {
    	$('#cont-buscar').fadeOut("slow");
    	$('#cont-fusuarios').fadeOut("slow");
    	$('#cont-listausuarios').fadeIn("slow");
    	$.get('usuario/muestraEditar', { 'id': 3 }, function (o){
        	$('#cont-editar').html(o);
		});
    	$.get('usuario/muestraLista', { 'id': 3 }, function (o){
        	$('#cont-listausuarios').html(o);
        	$.get('usuario/ajaxListaUsuarios', { 'permiso': 'prof' }, function (o){
        		for (var i = 0; i < o.length; i++) {
        			if (o[i].PERMISO == 1){
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><<td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td></tr>');
        			} else {
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><td>' + o[i].TELEFONO + '</td><td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td><td><a href="#" class="del" name="' + o[i].NOMBRES + '" rel="' + o[i].RUT + '">Eliminar</a></td></tr>');
        			}
        		}
        	}, 'json');
        	$('.editar').live('click', function () {
        		var id = $(this).attr('rel');
                $.post('usuario/ajaxListaUnUsuario', { 'id': id, 'permiso': 'prof' }, function (o) {
                	$('.rut-prof').attr('value', o[0].RUT);
                	$('#nombres-prof').attr('value', o[0].NOMBRES);
                	$('#apaterno-prof').attr('value', o[0].APATERNO);
                	$('#amaterno-prof').attr('value', o[0].AMATERNO);
                	$('#telefono-prof').attr('value', o[0].TELEFONO);
                	$('#username-prof').attr('value', o[0].USERNAME);
                	$('#password-prof').attr('value', o[0].PASSWD);
                	$('#email-prof').attr('value', o[0].EMAIL);
                	$('#modal-editar').modal();
                }, 'json');
        	});
        	$('#form-editar-profesor').live('submit', function () {
                var url = $(this).attr('action');
                var data = $(this).serialize();
                $.post(url, data, function (o) {
                	/**:P**/
                }, 'json');
                $('.inputusuario').val("");
                $("#alerta-editar-prof").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-editar-prof").slideUp();
                }, 2500);
                $('#modal-editar').modal('hide');
                return false;
            });
        	$('.del').live('click', function () {
        		var id = $(this).attr('rel');
        		$('#usuario-eliminar strong').remove();
        		var nombre = $(this).attr('name');
				$('#usuario-eliminar').append('<strong>' + nombre + '</strong>');
				$('#eliminar').attr('rel', id);
        		$('#modal-eliminar').modal();
			});
        	$('.del').live('click', function () {
        		var id = $(this).attr('rel');
        		$('#usuario-eliminar strong').remove();
        		var nombre = $(this).attr('name');
				$('#usuario-eliminar').append('<strong>' + nombre + '</strong>');
				$('#eliminar').attr('rel', id);
        		$('#modal-eliminar').modal();
			});
        	$('#eliminar').click( function () {
        		var id = $(this).attr('rel');
        		var delItem = $('#fila-' + id);
				$.post('usuario/ajaxDeshabilitar', {
					'rut': id
				}, function (o) {
					delItem.remove();
				}, 'json');
				$("#alerta-eliminar-prof").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-eliminar-prof").slideUp();
                }, 2500);
    		});
        });
    });
    
    $('#listar-alumno').click(function () {
    	$('#cont-fusuarios').fadeOut("slow");
    	$('#cont-buscar').fadeOut("slow");
    	$('#cont-listausuarios').fadeIn("slow");
    	$.get('usuario/muestraEditar', { 'id': 4 }, function (o){
        	$('#cont-editar').html(o);
		});
    	$.get('usuario/muestraLista', { 'id': 4 }, function (o){
        	$('#cont-listausuarios').html(o);
        	$.get('usuario/ajaxListaUsuarios', { 'permiso': 'alum' }, function (o){
        		for (var i = 0; i < o.length; i++) {
        			if (o[i].PERMISO == 1){
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><<td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td></tr>');
        			} else {
        				$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><td>' + o[i].SEXO + '</td><td>' + o[i].DIRECCION + '</td><td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td><td><a href="#" class="del" name="' + o[i].NOMBRES + '" rel="' + o[i].RUT + '">Eliminar</a></td></tr>');
        			}
        		}
        	}, 'json');
        	$('.editar').live('click', function () {
        		var id = $(this).attr('rel');
                $.post('usuario/ajaxListaUnUsuario', { 'id': id, 'permiso': 'alum' }, function (o) {
                	$('.rut-alum').attr('value', o[0].RUT);
                	$('#nombres-alum').attr('value', o[0].NOMBRES);
                	$('#apaterno-alum').attr('value', o[0].APATERNO);
                	$('#amaterno-alum').attr('value', o[0].AMATERNO);
                	$('#domicilio-alum').attr('value', o[0].DIRECCION);
                	$('#username-alum').attr('value', o[0].USERNAME);
                	$('#password-alum').attr('value', o[0].PASSWD);
                	$('#email-alum').attr('value', o[0].EMAIL);
                	$('#modal-editar').modal();
                }, 'json');
        	});
        	$('#form-editar-alumno').live('submit', function () {
                var url = $(this).attr('action');
                var data = $(this).serialize();
                $.post(url, data, function (o) {
                	/**:P**/
                }, 'json');
                $('.inputusuario').val("");
                $("#alerta-editar-alum").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-editar-alum").slideUp();
                }, 2500);
                $('#modal-editar').modal('hide');
                return false;
            });
        	$('.del').live('click', function () {
        		var id = $(this).attr('rel');
        		$('#usuario-eliminar strong').remove();
        		var nombre = $(this).attr('name');
				$('#usuario-eliminar').append('<strong>' + nombre + '</strong>');
				$('#eliminar').attr('rel', id);
        		$('#modal-eliminar').modal();
			});        	
        	$('#eliminar').click(function () {	
        		var id = $(this).attr('rel');
        		var delItem = $('#fila-' + id);
        		$.post('usuario/ajaxDeshabilitar', {
        			'rut': id
        		}, function (o) {
        			delItem.remove();
        		}, 'json');
        		$("#alerta-eliminar-alum").animate({ 'height':'toggle','opacity':'toggle'});
                window.setTimeout( function(){
                    $("#alerta-eliminar-alum").slideUp();
                }, 2500);
        	});
        });
    });
    $('#fusuarios').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	$("#alerta-creacion").animate({ 'height':'toggle','opacity':'toggle'});
            window.setTimeout(function(){
                $("#alerta-creacion").slideUp();
            }, 2500);
        }, 'json');
        $('.inputusuario').val("");
        return false;
    });

    $('.buscar').click(function() {
    	$('#cont-fusuarios').fadeOut("slow");
    	$('#cont-listausuarios').fadeOut("slow");
    	$('#cont-buscar').fadeIn("slow");
    	var id = $(this).attr('id');
    	$.get('usuario/muestraBuscar', { 'listar': id }, function (o){
        	$('#cont-buscar').html(o);
        });
    });
    $('#form-buscar-usuario').live('submit', function () {
    	$('#cont-resultado-ninguno p').fadeOut("slow");
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	if (o == null){
        		$('#cont-resultado-busqueda').attr('style', 'display:none');
        		$('#cont-resultado-ninguno').append('<p>No se encontr&oacute; ning&uacute;n resultado </p>');
        		$('#cont-resultado-ninguno').fadeIn("slow");
        		return false;
        	}
        	$('#cont-resultado-busqueda').fadeIn("slow");
        	$('#cont-resultado-busqueda tr:nth-child(n+2)').remove();
        	for (var i = 0; i < o.length; i++) {
        		$('#tabla-resultado-busqueda').append('<tr id="fila-' + i + '" class="lista-usu"><td>' + o[i].RUT + '</td><td>' + o[i].NOMBRES + '</td><td>' + o[i].APATERNO + '</td><td>' + o[i].AMATERNO + '</td><td>' + o[i].USERNAME + '</td><td>' + o[i].EMAIL + '</td><td>' + o[i].PERMISO + '</td></tr>');
        	}
        }, 'json');
        $('#buscador-usuario').val("");
        return false;
    });
});