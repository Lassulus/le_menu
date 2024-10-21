# le Menu

A simple menu builder.

example:
flake.nix
```nix
      ...
      packages = {
        default = inputs.le_menu.lib.buildMenu {
          inherit pkgs;
          menuConfig = {
            nvim.run = "nix run path://${self}#nvim";
            shell.run = "nix run path://${self}#shell";
            machines.submenu = {
              ignavia.run = "nix run path://${self}#machines.ignavia.system.build.menu
            };
            debug.run = "env";
          };
        };
      };
      ...
```
