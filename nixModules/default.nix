{ pkgs, inputs, lib, config, arch, username, std, ... }:
let
  conf = config // {
    colorscheme = import ./colorschemes.nix { colorscheme = "catppuccin"; };
    username = username;
  };
in {
  imports = [
    (import ./security { inherit conf inputs std pkgs lib config; })
    (import ./gui { inherit conf inputs pkgs lib std; })
    (import ./tools { inherit conf pkgs lib std inputs; })
    ./system
    ./hardware
    (import ./network { inherit conf lib std; })
  ];

  options = {
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
    colorscheme = {
      text = "FFFFFF";
      accent1 = "C5A8EB";
      accent2 = "C9CBFF";
      background1 = "170E1F";
      background2 = "140F21";
      error = "CA8080";
      special = "A6E3A1";
      inactive = "1E1E2E";
      warn = "DD7878";
    };

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
        config.window-manager = {
          enable = true;
          name = "Hyprland";
        };
      in {
        imports =
          [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
        environment.etc."specialisation".text = "Hyprland";
      };
      Sway.configuration = let
        config.window-manager = {
          enable = true;
          name = "sway";
        };
      in {
        imports =
          [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
        environment.etc."specialisation".text = "sway";
      };
      niri.configuration = let
        config.window-manager = {
          enable = true;
          name = "niri";
        };
      in {
        imports =
          [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
        environment.etc."specialisation".text = "niri";
      };
    };
  };
}
