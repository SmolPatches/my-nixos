{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
  ];
  programs = {
    ssh = {
      enable = true;
    };
  };
}


