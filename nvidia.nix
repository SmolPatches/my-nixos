{
	hardware.nvidia.modesetting.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.opengl.enable = true;
}