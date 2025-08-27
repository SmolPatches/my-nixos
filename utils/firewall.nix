{ config, pkgs, enable_localsend ? false, ... }:
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    firewall.trustedInterfaces = [ "virbr0" ];
    nftables = {
      enable = true;
    };
    firewall = {
      enable = false;
      allowPing = true;
      #package = pkgs.nftables; # use nftables
      allowedTCPPorts = [ 80 443 22 8000 8080 3000 ] ++ (if enable_localsend then [ 53317 ] else [ ]);
      allowedUDPPorts = [ 51820 ] ++ (if enable_localsend then [ 53317 ] else [ ]);
    };
  };

}
