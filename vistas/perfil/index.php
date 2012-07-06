<div class="hero-unit" style="overflow: hidden;">
  <h2>
    Perfil de
    <?php echo $this->perfil[0]['USERNAME'] ?>
  </h2>
  <div id="cont-perfil" class="row">
    <div class="span6">
      <div class="row">
        <div class="span3">
          <p>RUT</p>
          <p>Nombres</p>
          <p>Apellido Paterno</p>
          <p>Apellido Materno</p>
          <p>Nombre de usuario</p>
          <p>Email</p>
          <p>Contrase&ntilde;a</p>
        </div>
        <div class="span3">
          <p>
            <?php echo $this->perfil[0]['RUT'] ?>
          </p>
          <p>
            <?php echo $this->perfil[0]['NOMBRES'] ?>
          </p>
          <p>
            <?php echo $this->perfil[0]['APATERNO'] ?>
          </p>
          <p>
            <?php echo $this->perfil[0]['AMATERNO'] ?>
          </p>
          <p>
            <?php echo $this->perfil[0]['USERNAME'] ?>
          </p>
          <p>
            <?php echo $this->perfil[0]['EMAIL'] ?>
          </p>
          <p>
            { encriptada } <a href="#">cambiar</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
