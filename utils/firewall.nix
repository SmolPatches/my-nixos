{ config, pkgs, enable_localsend ? false, ... }:
{
  networking = {
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      package = pkgs.nftables;
      allowedTCPPorts = [ 80 443 22 8000 ] ++ (if enable_localsend then [ 53317 ] else [ ]);
      allowedUDPPorts = [ ] ++ (if enable_localsend then [ 53317 ] else [ ]);
    };
  };

}
