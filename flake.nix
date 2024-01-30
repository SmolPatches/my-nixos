# how to add an overlay to a flake in here
# https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #for use in home-manager
    hyprland.url = "github:hyprwm/Hyprland";
    #secrets
    agenix.url = github:ryantm/agenix;
  };

  # add sops.nix
  # and refactor flake for multiple machines
  # including nix-darwin
  # inspired by https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  #outputs = { self, nixpkgs, flake-utils, home-manager, sops-nix, hyprland }: {
  outputs = { nixpkgs, ... } @inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # ...
      system = "x86_64-linux"; #builtins.currentSystem;
      specialArgs = { inherit inputs; };
      modules = [
        inputs.agenix.nixosModules.default
        ./configuration.nix
        #stolen from https://rycee.gitlab.io/home-manager/index.html#sec-flakes-nixos-module
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.watashi = import ./conf/home.nix;
        }
      ];
    };
    homeConfigurations = {
      "g0vib@m1" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        modules = [
          ./users/g0vib.nix
          ./users/common.nix
          {
            home = {
              username = "g0vib";
              homeDirectory = "/home/g0vib";
              stateVersion = "23.05";
            };
          }
          # install hyprland
          inputs.hyprland.homeManagerModules.default
          {
            wayland.windowManager.hyprland = {
              enable = true;
              xwayland = {
                enable = false;
              };
            };
          }
        ];
      };
    };
  };
}
