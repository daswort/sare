<?php

require 'config.php';

function __autoload($clase) {
	
	require LIBS . $clase .".php";
}

$app = new Bootstrap();