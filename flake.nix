{
  description = "generate menus via different backends";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, lib, ... }:
      let
        runners = builtins.filter (x: x != "le_menu") (lib.attrNames (builtins.readDir ./bin));
      in
      {
        imports = [ ./treefmt.nix ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "riscv64-linux"

          "x86_64-darwin"
          "aarch64-darwin"
        ];
        flake.lib = import ./lib { inherit lib runners; };
        flake.nixosModules = {
          le_menu =
            { ... }:
            {
              options = {
                runners = lib.mkOption {
                  type = lib.types.listOf lib.types.enum runners;
                  default = [ ];
                };
                menu = self.lib.types.menuType;
              };
            };
        };
        perSystem =
          { pkgs, self', ... }:
          {
            packages =
              (lib.genAttrs runners (
                name:
                pkgs.writeShellApplication {
                  name = "le_menu_${name}";
                  runtimeInputs = [ self'.packages.le_menu ] ++ self.lib.getDepsFromNixShell pkgs ./bin/${name};
                  text = builtins.readFile ./bin/${name};
                }
              ))
              // {
                le_menu = pkgs.writeShellApplication {
                  name = "le_menu";
                  runtimeInputs = [ pkgs.jq ];
                  text = builtins.readFile ./bin/le_menu;
                };
              };
          };
      }
    );
}
