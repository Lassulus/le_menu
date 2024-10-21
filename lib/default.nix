{ lib, ... }:
let
  getDepsFromNixShell =
    pkgs: file:
    let
      fileContent = builtins.readFile file;
      depsAsStr = lib.splitString " " (
        builtins.head (builtins.match ".*nix-shell -i bash -p ([^\n]*).*" fileContent)
      );
      deps = map (dep: pkgs.${dep}) depsAsStr;
    in
    deps;

  types = import ./types.nix { inherit lib; };

  buildMenu =
    {
      pkgs,
      menuConfig,
      extraDeps ? [ ],
      runner ? pkgs.fzf,
    }:
    let
      cfg =
        (lib.evalModules {
          modules = [
            { options.menu = types.menuOption; }
            { menu = menuConfig; }
          ];
        }).config.menu;
      json = builtins.toJSON cfg;
      jsonFile = pkgs.writeText "menu.json" json;
    in
    pkgs.writeShellApplication {
      name = "le_menu";
      runtimeInputs = [
        pkgs.jq
      ] ++ extraDeps;
      text = ''
        export RUNNER=${runner}
        bash ${../bin/le_menu} < ${jsonFile}
      '';
    };
in
{
  inherit getDepsFromNixShell types buildMenu;
}
