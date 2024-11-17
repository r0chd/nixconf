{ pkgs, inputs, lib, hostname, pkgs-stable, config, username, std, ... }:
let
in {
  imports = [ ./network ];

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs hostname pkgs pkgs-stable username std;
    };
    users."${username}" = {
      options = {
        outputs = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule {
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
          });
          default = { };
        };
        font = lib.mkOption { type = lib.types.str; };
        email = lib.mkOption { type = lib.types.str; };
        initialPassword = lib.mkOption { type = lib.types.str; };
      };
      imports = [
        ./tools
        ./gaming
        ./gui
        ./colorschemes.nix
        ./security
        inputs.sops-nix.homeManagerModules.sops
        inputs.seto.homeManagerModules.default
      ];
      config = {
        programs.home-manager.enable = true;
        home = {
          packages = with pkgs; [
            nvd
            nix-output-monitor
            just
            (writeShellScriptBin "shell" ''
              nix develop "${std.dirs.config}#devShells.$@.${pkgs.system}" -c ${
                config.home-manager.users.${username}.shell
              }
            '')

            (writeShellScriptBin "rebuild" ''
              nix build '${std.dirs.home}/nixconf#nixosConfigurations.""laptop"".config.system.build.toplevel' --log-format internal-json --verbose --out-link /tmp/nh-osxg4u7B/result | nom --json
              nvd diff /run/current-system /tmp/nh-osxg4u7B/result
            '')

            (writeShellScriptBin "nb" ''
              command "$@" > /dev/null 2>&1 &
              disown
            '')
          ];
          username = "${username}";
          stateVersion = config.system.stateVersion;
        };
      };
    };
  };

  specialisation = {
    Hyprland.configuration = let
      window-manager = {
        enable = true;
        name = "Hyprland";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "Hyprland";
      imports = [
        (import ./environments {
          inherit config inputs pkgs lib username window-manager;
        })
      ];
    };
    Sway.configuration = let
      window-manager = {
        enable = true;
        name = "sway";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "sway";
      imports = [
        (import ./environments {
          inherit config inputs pkgs lib username window-manager;
        })
      ];
    };
    niri.configuration = let
      window-manager = {
        enable = true;
        name = "niri";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "niri";
      imports = [
        (import ./environments {
          inherit config inputs pkgs lib username window-manager;
        })
      ];
    };
  };
}
