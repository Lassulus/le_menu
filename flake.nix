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
      { lib, ... }:
      {
        imports = [ ./treefmt.nix ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "riscv64-linux"

          "x86_64-darwin"
          "aarch64-darwin"
        ];
        flake.nixosModules = {
          le_menu =
            { ... }:
            {
              options = {
                runners = lib.mkOption {
                  type = lib.types.listOf lib.types.enum [
                    "dmenu"
                    "rofi"
                  ];
                  default = [ ];
                };
              };
            };
        };
        perSystem =
          { ... }:
          {
          };
      }
    );
}
