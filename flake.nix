{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }: {
    /*let
      systems = [ "aarch64-linux" ];
      in
      #        flake-utils.lib.eachSystem systems (system:
        flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
        in
        {

        });*/
    #nixos configuration
    /*
        let
            user = if builtins.currentSystem == "x86_64-linux" then "watashi" else "rob";
        in
        */
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

