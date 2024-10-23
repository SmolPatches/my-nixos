# how to add an overlay to a flake in here
# https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixstable.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # use hyprland flake input so i can lock it
    # dont want to update unless something isn't working
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #secrets
    agenix.url = "github:ryantm/agenix";
  };

  # and refactor flake for multiple machines
  # including nix-darwin
  # inspired by https://gitlab.com/rprospero/dotfiles/-/blob/master/flake.nix
  #outputs = { self, nixpkgs, flake-utils, home-manager, sops-nix, hyprland }: {
  outputs = { nixpkgs, agenix, ... } @inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # use flake-input here? to add aarch64 support
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        #stolen from https://rycee.gitlab.io/home-manager/index.html#sec-flakes-nixos-module
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.watashi = import ./conf/home.nix;
        }
        agenix.nixosModules.default
        {
          # use a version of nixpkgs taking from flake-utils? so i can do it against various systems
          environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
        }
      ];
    };
  };
}
