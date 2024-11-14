{ pkgs, inputs, lib, config, username, std, ... }:
let
in {
  imports = [
    ./gui
    ./tools
    ./hardware
    ./network
    ./gaming
    ./security
    ./system
    ./colorschemes.nix
  ];

  options = {
    initialPassword = lib.mkOption { type = lib.types.str; };
    outputs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          position = {
            x = lib.mkOption { type = lib.types.int; };
            y = lib.mkOption { type = lib.types.int; };
          };
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

    email = lib.mkOption { type = lib.types.str; };
    font = lib.mkOption { type = lib.types.str; };
  };

  config = {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    home-manager = {
      backupFileExtension = "backup";
      users."${username}" = {
        programs.home-manager.enable = true;
        home = {
          username = "${username}";
          stateVersion = "24.05";
        };
      };
    };

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [ "root" "${username}" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    users = let sops = config.sops;
    in {
      # Disable mutable user if sops manages password
      mutableUsers = (!sops.enable || !sops.managePassword);
      users."${username}" = {
        isNormalUser = true;

        # If sops manages password look for hashedPasswordFile otherwise require initialPassword
        hashedPasswordFile = lib.mkIf (sops.enable && sops.managePassword)
          config.sops.secrets.password.path;
        initialPassword = lib.mkIf (!sops.enable || !sops.managePassword)
          config.initialPassword;
        extraGroups = [ "wheel" ];
      };
    };

    environment.systemPackages = with pkgs; [
      nvd
      nix-output-monitor
      just
      (writeShellScriptBin "shell" ''
        nix develop "${std.dirs.config}#devShells.$@.${pkgs.system}" -c ${config.shell}
      '')

      (writeShellScriptBin "rebuild" ''
        sudo nix build '/home/unixpariah/nixconf#nixosConfigurations.""laptop"".config.system.build.toplevel' --log-format internal-json --verbose --out-link /tmp/nh-osxg4u7B/result | nom --json
        nvd diff /run/current-system /tmp/nh-osxg4u7B/result
      '')

      (writeShellScriptBin "nb" ''
        command "$@" > /dev/null 2>&1 &
        disown
      '')
    ];

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
  };
}
