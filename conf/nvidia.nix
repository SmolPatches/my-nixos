{ config, lib, pkgs, modulesPath, ... }:
{
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58";

      sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = lib.fakeSha256;
      settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
      persistencedSha256 = lib.fakeSha256;
    };
    #package = config.boot.kernelPackages.nvidiaPackages.stable; #config.boot.kernelPackages.nvidiaPackages.beta;
  };
#  boot.kernelParams = [
#    "nvidia-drm.modeset=1"
#    "nvidia-drm.fbdev=1"
#  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  #services.xserver.videoDrivers = [ "nouveau" ];
  hardware.graphics = {
    enable = true;
    #    driSupport = true;
    #    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
