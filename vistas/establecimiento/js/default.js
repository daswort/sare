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
        $.get('establecimiento/muestraLista', function (o){
        	$('#cont-listaestablecimientos').html(o);
        	$.get('establecimiento/ajaxListaEstablecimientos', function (o) {
        		for (var i = 0; i < o.length; i++) {
    				$('#tabla-listaestablecimientos').append('<tr id="fila-' + o[i].CODIGO + '" class="lista-est">' + '<td>' + o[i].CODIGO + '</td>' + '<td>' + o[i].NOMBRE + '</td>' + '<td>' + o[i].DIRECCION + '</td>' + '<td>' + o[i].NOMBRE_COMUNA + '</td>' + '<td>' + o[i].NOMBRE_PROVINCIA + '</td>' + '<td>' + o[i].NOMBRE_REGION + '</td>' + '<td><a href="#" class="editar" name="modal" rel="' + o[i].CODIGO + '">Editar</a></td>' + '<td><a href="#" class="del" rel="' + o[i].CODIGO + '">Eliminar</a></td>' + '</tr>');
    			}
        		$('.editar').click(function () {
        			var id = $(this).attr('rel');
        			$.post('establecimiento/ajaxListaUnEstablecimiento', { 'codigo': id }, function (o) {
        				
        			});
        		});
    		}, 'json');
        });
    });
});