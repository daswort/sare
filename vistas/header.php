<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8" />
    <title>S A R E</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />

    <link rel="stylesheet" media="all" href="<?php echo URL; ?>publico/css/bootstrap.css" />	
	<link rel="stylesheet" media="all" href="<?php echo URL; ?>publico/css/jquery-ui.css" />
	<link rel="stylesheet" media="all" href="<?php echo URL; ?>publico/css/default.css" />
    <style type="text/css"> body { padding-top: 60px; padding-bottom: 40px; }</style>
    <link href="<?php echo URL; ?>publico/css/bootstrap-responsive.css" rel="stylesheet" />
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
  </head>
  <body>
    <?php Sesion::iniciar(); ?>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="<?php echo URL; ?>inicio">S A R E</a>
          <div class="nav-collapse">
            <ul class="nav">
			  <?php if (Sesion::get('logeado') == false): ?>
			    <li <?php echo($_GET['url'] == 'login' ?  'class="active"' : ''); ?>><a href="<?php echo URL; ?>login"><i class="icon-play-circle icon-white"></i> Iniciar Sesi&oacute;n</a></li>
			    <li <?php echo($_GET['url'] == 'ayuda' ?  'class="active"' : ''); ?>><a href="<?php echo URL; ?>ayuda"><i class="icon-question-sign icon-white"></i> Ayuda</a></li>
			  <?php else: ?>
				<li <?php echo($_GET['url'] == 'inicio' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>inicio"><i class="icon-home icon-white"></i> Inicio</a></li>
			    <?php if (Sesion::get('rol') == 1): ?>
				  <li <?php echo($_GET['url'] == 'establecimiento' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>establecimiento"><i class="icon-bell icon-white"></i> Establecimientos</a></li>
				  <li <?php echo($_GET['url'] == 'usuario' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>usuario"><i class="icon-user icon-white"></i> Usuarios</a></li>
				  <li <?php echo($_GET['url'] == 'feedback' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>feedback"><i class="icon-refresh icon-white"></i> Feedback</a></li>
				  <li <?php echo($_GET['url'] == 'reporte' ?  'class="active"' : ''); ?>><a href="<?php echo URL; ?>reporte"><i class="icon-list-alt icon-white"></i> Reportes</a></li>
				<?php endif; ?>
				<?php if (Sesion::get('rol') == 2): ?>
				  <li <?php echo($_GET['url'] == 'establecimiento' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>establecimiento"><i class="icon-bell icon-white"></i> Establecimientos</a></li>
				  <li <?php echo($_GET['url'] == 'usuario' ? 'class="active"' : ''); ?>><a href="<?php echo URL; ?>usuario"><i class="icon-user icon-white"></i> Usuarios</a></li>
				<?php endif; ?>
				<?php if (Sesion::get('rol') == 3): ?>
				<?php endif; ?>
				<?php if (Sesion::get('rol') == 4): ?>
				<?php endif; ?>
				<li class="dropdown" id="menu1">
                  <a class="dropdown-toggle" data-toggle="dropdown" href="#menu1"> Bienvenido <?php echo Sesion::get('usuario'); ?> <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="<?php echo URL; ?>perfil"><i class="icon-user"></i> Perfil</a></li>
                    <li><a href="#"><i class="icon-cog"></i> Configuraci&oacute;n</a></li>
                    <li><a href="<?php echo URL; ?>ayuda"><i class="icon-question-sign"></i> Ayuda</a></li>
                    <li class="divider"></li>
                    <li><a href="<?php echo URL; ?>login/deslogear"><i class="icon-off"></i> Cerrar Sesi&oacute;n</a></li>
                  </ul>
                </li>
			  <?php endif; ?>
            </ul>
			
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	<section class="container">