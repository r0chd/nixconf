{ pkgs, inputs, lib, config, arch, username, std, ... }:
let
in {
  imports = [ ./gui ./tools ./hardware ./network ./gaming ./security ./system ];

  options = {
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
    theme = lib.mkOption { type = lib.types.enum [ "catppuccin" ]; };
    colorscheme = {
      name = lib.mkOption { type = lib.types.enum [ "catppuccin" ]; };
      text = lib.mkOption { type = lib.types.str; };
      accent1 = lib.mkOption { type = lib.types.str; };
      accent2 = lib.mkOption { type = lib.types.str; };
      background1 = lib.mkOption { type = lib.types.str; };
      background2 = lib.mkOption { type = lib.types.str; };
      error = lib.mkOption { type = lib.types.str; };
      special = lib.mkOption { type = lib.types.str; };
      inactive = lib.mkOption { type = lib.types.str; };
      warn = lib.mkOption { type = lib.types.str; };
    };
    font = lib.mkOption { type = lib.types.str; };
    hostname = lib.mkOption { type = lib.types.str; };
  };

  config = {
    colorscheme = (import ./colorschemes.nix)."${config.theme}";

    boot.kernelPackages = pkgs.linuxPackages_latest;

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

    users = {
      mutableUsers = false;
      users."${username}" = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.password.path;
        extraGroups = [ "wheel" ];
      };
    };

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "shell" ''
        nix develop "${std.dirs.config}#devShells.$@.${arch}" -c ${config.shell}
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
