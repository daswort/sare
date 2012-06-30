/*
 ** Autor: Jacob Vidal.
 */
 
function mostrarRegiones(idSelect) {
	$.get('establecimiento/selectRegiones', function (o) {
        for (var i = 0; i < o.length; i++) {
            $('#' + idSelect).append('<option value="' + o[i].ID + '">' + o[i].NOMBRE_REGION + '</option>');
        }
    }, 'json');
 }
 
function mostrarProvincias(val, idSelect) {
	$.get('establecimiento/selectProvincias', {
        'id': val
    }, function (o) {
        for (var i = 0; i < o.length; i++) {
            $('#' + idSelect).append('<option class="opcion-prov" value="' + o[i].ID + '">' + o[i].NOMBRE_PROVINCIA + '</option>');
        }
	}, 'json'); 
 }
 
function mostrarComunas(val, idSelect) {
	$.get('establecimiento/selectComunas', {
		'id': val
    }, function (o) {
        for (var i = 0; i < o.length; i++) {
            $('#' + idSelect).append('<option class="opcion-comuna" value="' + o[i].ID + '">' + o[i].NOMBRE_COMUNA + '</option>');
        }
    }, 'json');
 }
 
function comboboxRegiones(idSelectRegiones, idSelectProvincias, idSelectComunas) {
	mostrarRegiones(idSelectRegiones);

    $('select:not(#' + idSelectComunas + ')').change(function () {
        var ID = $(this).attr("id");
        var val = $(this).val();

        if (ID == idSelectRegiones) {
            $('.opcion-prov').remove();
            $('.opcion-comuna').remove();
            if (val != 0) {
                mostrarProvincias(val, idSelectProvincias);
                $('#' + idSelectProvincias).attr('disabled', false);
                $('#' + idSelectComunas).attr('disabled', true);
            } else {
                $('#' + idSelectProvincias).attr('disabled', true);
                $('#' + idSelectComunas).attr('disabled', true);
            }

        } else if (ID == idSelectProvincias) {
            $('.opcion-comuna').remove();
            if (val != 0) {
                mostrarComunas(val, idSelectComunas);
                $('#' + idSelectComunas).attr('disabled', false);
            } else {
                $('#' + idSelectComunas).attr('disabled', true);
            }
        }
    });
 }
 
$(function () {

    $('#agregar').click(function () {
        $('#cont-listaestablecimientos').fadeOut("slow");
        $('#cont-festablecimientos').fadeIn("slow");
    });

    $('#listar').click(function () {
		
    	$('.lista-est').remove();
        $('#cont-festablecimientos').fadeOut("slow");
        $('#cont-listaestablecimientos').fadeIn("slow");
		
		$.get('establecimiento/ajaxListaEstablecimientos', function (o) {

			for (var i = 0; i < o.length; i++) {
				$('#tabla-listaestablecimientos').append('<tr id="fila-' + o[i].CODIGO + '" class="lista-est">' + '<td>' + o[i].CODIGO + '</td>' + '<td>' + o[i].NOMBRE + '</td>' + '<td>' + o[i].DIRECCION + '</td>' + '<td>' + o[i].NOMBRE_COMUNA + '</td>' + '<td>' + o[i].NOMBRE_PROVINCIA + '</td>' + '<td>' + o[i].NOMBRE_REGION + '</td>' + '<td><a href="#" class="editar" name="modal" rel="' + o[i].CODIGO + '">Editar</a></td>' + '<td><a href="#" class="del" rel="' + o[i].CODIGO + '">Eliminar</a></td>' + '</tr>');
			}
			
			$('.editar').click(function () {
				
				var id = $(this).attr('rel');
				$.get('establecimiento/ajaxListaUnEstablecimiento', {
					'codigo': id
				}, function (o) {
					$('.input-editar').remove();
					$('#form-editar').append('<div class="input-editar" style="float:left"><label>C&oacute;digo</label><input id="codigo-est" type="text" name="codigo" autofocus = "autofocus" required = "required" value="' + o[0].CODIGO + '" disabled="disabled" /><br />' +
									 '<label>Nombre</label><input id="nombre-est" type="text" name="nombre" required = "required" value="' + o[0].NOMBRE + '" /><br />' +
									 '<label>Direcci&oacute;n</label><input id="direccion-est" type="text" name="direccion" required = "required" value="' + o[0].DIRECCION + '" /><br /></div>' +
									 '<div class="input-editar"  style="float:right"><label>Regi&oacute;n</label><select id="select-regiones-ed" class="inputestablecimiento" name="region"><option value="' + o[0].ID_REGION + '">' + o[0].NOMBRE_REGION + '</option></select><br />' +
									 '<label>Provincia</label><select id="select-provincias-ed" class="inputestablecimiento" name="provincia" disabled="disabled"><option value="' + o[0].ID_PROVINCIA + '">' + o[0].NOMBRE_PROVINCIA + '</option></select><br />' +
									 '<label>Comuna</label><select id="select-comunas-ed" class="inputestablecimiento" name="comuna" disabled="disabled"><option value="' + o[0].ID_COMUNA + '">' + o[0].NOMBRE_COMUNA + '</option></select><br />' +
									 '<label>&nbsp;</label><input class="btn btn-primary btn-submit-form" type="submit" /></div>'
					);
					comboboxRegiones('select-regiones-ed','select-provincias-ed','select-comunas-ed');
				}, 'json');
				
				$("#cont-editar").dialog({
					height: 430,
					title: 'Editar Establecimiento',
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
					var codigo = $('input[id="codigo-est"]').val();
					var nombre = $('input[id="nombre-est"]').val();
					var direccion = $('input[id="direccion-est"]').val();
					var comuna = $('select[id="select-comunas-ed"]').val();
					
					$.post(url, {codigo: codigo, nombre: nombre, direccion: direccion, comuna: comuna}, function (o) {
						$('#mensaje').append('Establecimiento editado');
						$("#mensaje").fadeOut(4000);
					}, 'json');
					//$('.inputestablecimiento').val("");
					return false;
				});
			});

			$('.del').live('click', function () {
				var id = $(this).attr('rel');
				delItem = $('#fila-' + id);
				$.post('establecimiento/ajaxDeshabilitar', {
					'codigo': id
				}, function (o) {
					delItem.remove();
				}, 'json');
				return false;
			});
		}, 'json');
    });

    comboboxRegiones('select-regiones-cr','select-provincias-cr','select-comunas-cr');

    $('#festablecimientos').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
            $('#mensaje').append('<p>Establecimiento Ingresado</p>');
			$("#mensaje").fadeOut(4000);
        }, 'json');
        $('.inputestablecimiento').val("");
		return false;
    });
});