{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "i686-linux"
      ];
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.hello = pkgs.hello;
        nixosModules = import ./modules/nixos { inherit inputs self; };
        homeModules = import ./modules/home-manager { inherit inputs self; };
      });
}
