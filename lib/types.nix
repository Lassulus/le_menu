{ lib, ... }:
let
  menuType = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options = {
            run = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            submenus = lib.mkOption {
              type = lib.types.nullOr menuType;
              default = null;
            };
            _action = lib.mkOption {
              type = lib.types.enum [
                "run"
                "submenu"
              ];
              internal = true;
              default =
                if config.run != null then
                  "run"
                else if config.submenus != null then
                  "submenu"
                else
                  throw "no suitable action found";
            };
          };
        }
      )
    );
  };

in
{
  inherit menuType;
}
