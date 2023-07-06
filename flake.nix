{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
# allow nvim-qt to use nvim packages
# https://discourse.nixos.org/t/plugins-for-neovim-are-not-installed-for-neovim-qt/29712/5
#    nixpkgs.config = {
#      packageOverrides = pkgs: {
#      neovim-qt = pkgs.neovim-qt.override { inherit (myPackages) neovim; };
#      };
#    };
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    #for use in home-manager
    hyprland.url = "github:hyprwm/Hyprland";
  };

  # add sops.nix
  # and refactor flake for multiple machines
  # including nix-darwin
  # inspired by https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  outputs = { self, nixpkgs, flake-utils, home-manager, sops-nix, hyprland }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # ...
      system = "x86_64-linux"; #builtins.currentSystem;
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        #stolen from https://rycee.gitlab.io/home-manager/index.html#sec-flakes-nixos-module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.watashi = import ./home.nix;
        }
      ];
    };
    homeConfigurations = {
      "g0vib@m1" = home-manager.lib.homeManagerConfiguration {
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
          hyprland.homeManagerModules.default
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
