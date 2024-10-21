{ lib, ... }:
let
  menuType = lib.types.attrTag {
    run = lib.mkOption {
      type = lib.types.str;
    };
    submenu = lib.mkOption {
      type = lib.types.attrsOf menuType;
    };
  };
in
{
  menuOption = lib.mkOption {
    type = lib.types.attrsOf menuType;
  };
}
