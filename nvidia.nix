{
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    extraPackages = (with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ]);
  };
}
