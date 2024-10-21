{ lib, ... }:
let
  menuType = lib.types.attrTag {
    run = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    submenu = lib.mkOption {
      type = lib.types.nullOr menuType;
      default = null;
    };
  };
in
{
  menuOption = lib.mkOption {
    type = lib.types.attrsOf menuType;
  };
}
