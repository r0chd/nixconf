{
  pkgs,
  inputs,
  lib,
  hostname,
  pkgs-stable,
  config,
  std,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit
        inputs
        hostname
        pkgs
        pkgs-stable
        std
        ;
    };
    users = lib.genAttrs (lib.attrNames config.systemUsers) (user: {
      options = {
        outputs = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                position = {
                  x = lib.mkOption { type = lib.types.int; };
                  y = lib.mkOption { type = lib.types.int; };
                };
                refresh = lib.mkOption { type = lib.types.float; };
                dimensions = {
                  width = lib.mkOption { type = lib.types.int; };
                  height = lib.mkOption { type = lib.types.int; };
                };
                scale = lib.mkOption {
                  type = lib.types.int;
                  default = 1;
                };
              };
            }
          );
          default = { };
        };
        font = lib.mkOption { type = lib.types.str; };
        email = lib.mkOption { type = lib.types.str; };
      };
      imports = [
        "${std.dirs.host}/users/${user}/configuration.nix"
        ./environments
        ./tools
        ./gaming
        ./gui
        ./colorschemes.nix
        ./security
        ./network
        ./system
        inputs.impermanence.homeManagerModules.default
        inputs.sops-nix.homeManagerModules.sops
        inputs.seto.homeManagerModules.default
        inputs.niri.homeModules.niri
      ];
      config = {
        window-manager = config.window-manager;
        programs.home-manager.enable = true;
        home = {
          packages = with pkgs; [
            just
            nvd
            nix-output-monitor
            (writeShellScriptBin "shell" ''
              nix develop "${std.dirs.host}/../..#devShells.$@.${pkgs.system}" -c ${
                config.home-manager.users.${user}.shell
              }
            '')
            (writeShellScriptBin "specialisation" ''cat /etc/specialisation'')
            (writeShellScriptBin "nb" ''
              command "$@" > /dev/null 2>&1 &
              disown
            '')
          ];
          username = "${user}";
          stateVersion = config.system.stateVersion;
        };
      };
    });
  };
}
