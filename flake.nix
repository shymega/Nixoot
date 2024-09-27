{
  description = "Multi-boot boot image creator, supporting UEFI/GPT (+ BIOS/MBR). Fully transparent, with support for reproducible ISO inputs.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    ...
  } @ inputs: let
    genPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = let
          overlay-unstable = final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
            };
          };
        in [overlay-unstable];
      };
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "riscv32-linux"
      "riscv64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = genPkgs system;
    in {
      packages = {
        inherit (pkgs) grub2 hello;
        default = self.packages.${system}.hello;
      };
    })
    // {
      templates = {
        nixoot-basic-linux = {
          path = ./templates/nixoot-basic-linux;
          description = "A simple Nix Flake configuration template for a basic Nixoot image.";
        };
      };
    };
}
