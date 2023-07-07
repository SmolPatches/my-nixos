{
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
}
