{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # add sops.nix
  # and refactor flake for multiple machines
  # including nix-darwin
  # inspired by https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  outputs = { self, nixpkgs, flake-utils, home-manager }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # ...
      system = "x86_64-linux"; #builtins.currentSystem;
      modules = [
        ./configuration.nix
        #stolen from https://rycee.gitlab.io/home-manager/index.html#sec-flakes-nixos-module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.watashi = import ./home.nix;
        }
      ];
    };
  };
}

