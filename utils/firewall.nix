{ config, pkgs, enable_localsend ? false, ... }:
{
  networking.firewall = {
   enable = true;
   package = pkgs.nftables;
   allowedTCPPorts = [ 80 443 22 ] ++ (if enable_localsend then [53317] else []);
   allowedUDPPorts = [] ++ (if enable_localsend then [53317] else []);
  };
}
