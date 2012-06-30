/*
** Autor: Jacob Vidal.
*/

$(function () {
    
    $('#agregar-administrativo').click(function () {
        $('#cont-listausuarios').fadeOut("slow");
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
        $('#cont-fusuarios').fadeIn("slow");
        $.get('usuario/muestraForm', { 'id': 3 }, function (o){
        	$('#cont-fusuarios').html(o);
        });
    });
    
    $('#agregar-alumno').click(function () {
        $('#cont-listausuarios').fadeOut("slow");
        $('#cont-fusuarios').fadeIn("slow");
        $.get('usuario/muestraForm', { 'id': 4 }, function (o){
        	$('#cont-fusuarios').html(o);
        });
    });

    $('#listar').click(function () {
	
		$('.lista-usu').remove();
        $('#cont-fusuarios').fadeOut("slow");
        $('#cont-listausuarios').fadeIn("slow");
		
		$.get('usuario/ajaxListaUsuarios', function (o) {

			for (var i = 0; i < o.length; i++) {
				if (o[i].PERMISO == 1){
					$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu">' + '<td>' + o[i].RUT + '</td>' + '<td>' + o[i].NOMBRES + '</td>' + '<td>' + o[i].APATERNO + '</td>' + '<td>' + o[i].AMATERNO + '</td>' + '<td>' + o[i].USERNAME + '</td>' + '<td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td>' + '</tr>');
				} else {
					$('#tabla-listausuarios').append('<tr id="fila-' + o[i].RUT + '" class="lista-usu">' + '<td>' + o[i].RUT + '</td>' + '<td>' + o[i].NOMBRES + '</td>' + '<td>' + o[i].APATERNO + '</td>' + '<td>' + o[i].AMATERNO + '</td>' + '<td>' + o[i].USERNAME + '</td>' + '<td><a href="#" class="editar" name="modal" rel="' + o[i].RUT + '">Editar</a></td>' + '<td><a href="#" class="del" rel="' + o[i].RUT + '">Eliminar</a></td>' + '</tr>');
				}
			}
			
			
			$('.editar').click(function () {
				
				var id = $(this).attr('rel');
				$.get('usuario/ajaxListaUnUsuario', {
					'rut': id
				}, function (o) {
					$('.input-editar').remove();
					$('#form-editar').append(
						'<div class="input-editar" style="float:left">' +
							'<label>RUT</label><input id="rut-usu" type="text" name="rut" autofocus="autofocus" required="required" disabled="disabled" value="' + o[0].RUT + '" /><br />' +
							'<input type="text" name="rut" style="display: none;" value="' + o[0].RUT + '" />' +
							'<label>Nombres</label><input id="nombres-usu" type="text" name="nombres" required="required" value="' + o[0].NOMBRES + '" /><br />' +
							'<label>Apellido Paterno</label><input id="apaterno-usu" type="text" name="ap-pat" required="required" value="' + o[0].APATERNO + '" /><br />' +
							'<label>Apellido Materno</label><input id="amaterno-usu" type="text" name="ap-mat" required="required" value="' + o[0].AMATERNO + '" /><br />' + 
						'</div>' +
						'<div class="input-editar" style="float:right">' + 
							'<label>Nombre Usuario</label><input id="username-usu" type="text" name="username" required="required" value="' + o[0].USERNAME + '" /><br />' +
							'<label>Email</label><input id="email-usu" type="text" name="email" required="required" value="' + o[0].EMAIL + '" /><br />' +
							'<label>Contrase&ntilde;a</label><input id="passwd-usu" type="text" name="password" required="required" value="' + o[0].PASSWD + '" /><br />' +
							'<label>Permiso</label>' + 
							'<select id="permiso-usu" name="permiso">' + 
								'<option value="' + o[0].PERMISO + '">' + o[0].PERMISO_N + '</option>' +
								'<option value="2">Administrador</option>' +
								'<option value="3">Profesor</option>' +
								'<option value="4">Alumno</option>' +
							'</select><br />' +
							'<label>&nbsp;</label><input class="btn btn-primary btn-submit-form" type="submit" />' + 
						'</div>'
					);
				}, 'json');
				
				$("#cont-editar").dialog({
					height: 430,
					title: 'Editar Usuario',
					width: 600,
					hide: "drop",
					show: "drop",
					modal: true,
					closeOnEscape: true,
					buttons: {
						"Cerrar": function () {
							$(this).dialog("close");
						}
					}
				});
				
				$('#form-editar').live('submit', function () {
					var url = $(this).attr('action');
					var data = $(this).serialize();
					
					$.post(url, data, function (o) {
						$('#mensaje-e').append('Usuario editado');
						$("#mensaje-e").fadeOut(4000);
					}, 'json');
					//$('.inputestablecimiento').val("");
					return false;
				});
			});
			
			

			$('.del').live('click', function () {
				var id = $(this).attr('rel');
				delItem = $('#fila-' + id);
				$.post('usuario/ajaxDeshabilitar', {
					'rut': id
				}, function (o) {
					delItem.remove();
				}, 'json');
				return false;
			});
		}, 'json');
    });

    $('#fusuarios').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	$('#mensaje').append('<p>Usuario Ingresado</p>');
			$('#mensaje').fadeOut(4000);
			$('#mensaje').remove();
			$('#cont-msg').append('<div id="mensaje"></div>')
        }, 'json');
        $('.inputusuario').val("");
        return false;
    });
});