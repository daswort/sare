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
	$('#agregar-estab').click(function () {
        $('#cont-listaestablecimientos').fadeOut("slow");
        $('#cont-festablecimientos').fadeIn("slow");
        $.get('establecimiento/muestraForm', function (o){
        	$('#cont-festablecimientos').html(o);
        	comboboxRegiones('select-regiones-cr','select-provincias-cr','select-comunas-cr');
        });
    });
    $('#festablecimientos').live('submit', function () {
        var url = $(this).attr('action');
        var data = $(this).serialize();
        $.post(url, data, function (o) {
        	$("#alerta-creacion").animate({ 'height':'toggle','opacity':'toggle'});
            window.setTimeout( function(){
                $("#alerta-creacion").slideUp();
            }, 2500);
        }, 'json');
        $('.inputestablecimiento').val("");
		return false;
    });
    $('#listar-estab').click(function () {	
    	$('.lista-est').remove();
        $('#cont-festablecimientos').fadeOut("slow");
        $('#cont-listaestablecimientos').fadeIn("slow");
        $.get('establecimiento/muestraEditar', function (o){
        	$('#cont-editar').html(o);
		});
        $.get('establecimiento/muestraLista', function (o){
        	$('#cont-listaestablecimientos').html(o);
        	$.get('establecimiento/ajaxListaEstablecimientos', function (o) {
        		for (var i = 0; i < o.length; i++) {
    				$('#tabla-listaestablecimientos').append('<tr id="fila-' + o[i].CODIGO + '" class="lista-est">' + '<td>' + o[i].CODIGO + '</td>' + '<td>' + o[i].NOMBRE + '</td>' + '<td>' + o[i].DIRECCION + '</td>' + '<td>' + o[i].NOMBRE_COMUNA + '</td>' + '<td>' + o[i].NOMBRE_PROVINCIA + '</td>' + '<td>' + o[i].NOMBRE_REGION + '</td>' + '<td><a href="#" class="editar" name="modal" rel="' + o[i].CODIGO + '">Editar</a></td>' + '<td><a href="#" name="' + o[i].NOMBRE + '" class="del" rel="' + o[i].CODIGO + '">Eliminar</a></td>' + '</tr>');
    			}
        		$('.editar').click(function () {
        			$('#region-est option').remove();
        			$('#provincia-est option').remove();
        			$('#comuna-est option').remove();
        			var id = $(this).attr('rel');
        			$.post('establecimiento/ajaxListaUnEstablecimiento', { 'codigo': id }, function (o) {
        				$('.codigo-est').attr('value', o[0].CODIGO);
                    	$('#nombre-est').attr('value', o[0].NOMBRE);
                    	$('#direccion-est').attr('value', o[0].DIRECCION);
                    	var idReg = o[0].ID_REGION;
                    	$.get('establecimiento/selectRegiones', function (a){
                    		for (var i = 0; i < a.length; i++) {
                    			if (a[i].ID != idReg) {
                    				$('#region-est').append('<option value="' + a[i].ID + '">' + a[i].NOMBRE_REGION + '</option>');
                    			} else {
                    				$('#region-est').append('<option selected="selected" value="' + a[i].ID + '">' + a[i].NOMBRE_REGION + '</option>');
                    			}
                    		}
                    	}, 'json');
                    	var idProv = o[0].ID_PROVINCIA;
                    	$.get('establecimiento/selectProvincias', { 'id': idReg }, function (a){
                    		for (var i = 0; i < a.length; i++) {
                    			if (a[i].ID != idProv) {
                    				$('#provincia-est').append('<option value="' + a[i].ID + '">' + a[i].NOMBRE_PROVINCIA + '</option>');
                    			} else {
                    				$('#provincia-est').append('<option selected="selected" value="' + a[i].ID + '">' + a[i].NOMBRE_PROVINCIA + '</option>');
                    			}
                    		}
                    	}, 'json');
                    	var idCom = o[0].ID_COMUNA;
                    	$.get('establecimiento/selectComunas', { 'id': idProv }, function (a){
                    		for (var i = 0; i < a.length; i++) {
                    			if (a[i].ID != idCom) {
                    				$('#comuna-est').append('<option value="' + a[i].ID + '">' + a[i].NOMBRE_COMUNA + '</option>');
                    			} else {
                    				$('#comuna-est').append('<option selected="selected" value="' + a[i].ID + '">' + a[i].NOMBRE_COMUNA + '</option>');
                    			}
                    		}
                    	}, 'json');
                    	$('#modal-editar').modal();
        			}, 'json');
        		});
        		$('#region-est').change(function (){
            		var idReg = $('#region-est').val();
        			$('#provincia-est option').remove();
            		$.get('establecimiento/selectProvincias', { 'id': idReg }, function (o){
            			for (var i = 0; i < o.length; i++) {
            				$('#provincia-est').append('<option value="' + o[i].ID + '">' + o[i].NOMBRE_PROVINCIA + '</option>');
            			}
            		}, 'json');
            	});
        		$('#provincia-est').change(function (){
        			var idProv = $('#provincia-est').val();
        			$('#comuna-est option').remove();
            		$.get('establecimiento/selectComunas', { 'id': idProv }, function (o){
            			for (var i = 0; i < o.length; i++) {
            				$('#comuna-est').append('<option value="' + o[i].ID + '">' + o[i].NOMBRE_COMUNA + '</option>');
            			}
            		}, 'json');
        		});
        		$('#form-editar-establecimiento').live('submit', function () {
                    var url = $(this).attr('action');
                    var data = $(this).serialize();
                    $.post(url, data, function (o) {
                    	/**:P**/
                    }, 'json');
                    $('.inputusuario').val("");
                    $("#alerta-editar-est").animate({ 'height':'toggle','opacity':'toggle'});
                    window.setTimeout( function(){
                        $("#alerta-editar-est").slideUp();
                    }, 2500);
                    $('#modal-editar').modal('hide');
                    return false;
                });
        		$('.del').live('click', function () {
            		var id = $(this).attr('rel');
            		$('#establecimiento-eliminar strong').remove();
            		var nombre = $(this).attr('name');
    				$('#establecimiento-eliminar').append('<strong>' + nombre + '</strong>');
    				$('#eliminar').attr('rel', id);
            		$('#modal-eliminar').modal();
    			});
            	$('#eliminar').click( function () {
            		var id = $(this).attr('rel');
            		var delItem = $('#fila-' + id);
    				$.post('establecimiento/ajaxDeshabilitar', {
    					'codigo': id
    				}, function (o) {
    					delItem.remove();
    				}, 'json');
    				$("#alerta-eliminar-est").animate({ 'height':'toggle','opacity':'toggle'});
                    window.setTimeout( function(){
                        $("#alerta-eliminar-est").slideUp();
                    }, 2500);
        		});
    		}, 'json');
        });
    });
});