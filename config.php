<?php

define('URL', 'http://localhost/sare/');
define('LIBS', 'libs/');
$tns = '(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 190.151.26.37)(PORT = 1521))(CONNECT_DATA = (SID = whoracle))(SDU=2048)(TDU=2048))';
//$tns = '//152.74.180.7/whoracle';

////Contraseña base de datos: 87hkhkj87##$$5
define('BD_HOST', 'oci:dbname='. $tns .';charset=UTF8');
define('BD_USUARIO', 'grupo3');
define('BD_PASS', '87hkhkj87##$$5');

// hashkey general... NO BORRAR!
define('HASH_GENERAL_KEY', 'MixitUp200');

// hashkey para las contraseñas ingresadas a la base de datos
define('HASH_PASSWORD_KEY', 'catsFLYhigh2000miles');