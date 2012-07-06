
<footer>
  <p>
    Dise&ntilde;ado y Constru&iacute;do por <strong>ARJD
      Ingenier&iacute;a Web y Digital.</strong> C&oacute;digo licenciado
    por <a href="http://www.apache.org/licenses/LICENSE-2.0">Apache
      License v2.0.</a> Iconos y botones licenciados bajo CrativeCommons
    3.0.
  </p>
</footer>
</section>
<!-- /container -->

<script type="text/javascript" src="<?php echo URL; ?>publico/js/jquery.min.js"></script>
<script type="text/javascript" src="http://malsup.github.com/jquery.form.js"></script>
<script type="text/javascript" src="<?php echo URL; ?>publico/js/custom.js"></script>
<script type="text/javascript" src="<?php echo URL; ?>publico/js/bootstrap.js"></script>
<?php
if (isset($this->js)) {
  foreach ($this->js as $js){
    echo '<script type="text/javascript" src="'.URL.'vistas/'.$js.'"></script>';
  }
}
?>

</body>
</html>
