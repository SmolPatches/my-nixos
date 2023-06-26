{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  # add sops.nix
  # and refactor flake for multiple machines
  # including nix-darwin
  # inspired by https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  outputs = { self, nixpkgs, flake-utils, home-manager, sops-nix }: {
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
        ];
      };
    };
  };
}
