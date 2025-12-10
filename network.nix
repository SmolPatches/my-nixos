{ config, pkgs, ... }: let 
  wireguardKeys = pkgs.runCommand "wireguard-keys" { buildInputs = [ pkgs.wireguard-tools ]; } ''
            mkdir -p $out
            umask 077
            # Generate private and public keys
            wg genkey > $out/privatekey
            wg pubkey < $out/privatekey > $out/publickey
        ''; 
        in
{

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  services.jellyfin = {
    openFirewall = true;
    enable = true;
  };
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "${wireguardKeys}/privatekey";
      peers = [
        {
          publicKey = let f = "${wireguardKeys}/publickey"; in "${ builtins.readFile f}";
          allowedIPs = [ "10.100.0.1/32" ];
        }
      ];
    }; 
  };
}
