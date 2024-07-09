{
  userConfig,
  pkgs,
  inputs,
  lib,
  config,
}: let
  inherit (userConfig) username;
  helpers = {
    disableAll = lib.hasAttr "disableAll" userConfig && userConfig.disableAll == true;

    checkAttribute = attribute: opt:
      !helpers.disableAll && lib.hasAttr attribute userConfig && userConfig.${attribute} == "${opt}";

    isEnabled = attribute:
      lib.hasAttr attribute userConfig && userConfig.${attribute} == true;

    isDisabled = attribute:
      helpers.disableAll
      || (lib.hasAttr attribute userConfig && userConfig.${attribute} == false)
      && !helpers.isEnabled attribute;
  };
in {
  imports = [
    (import ./security/default.nix {inherit inputs userConfig pkgs;})
    (import ./gui/default.nix {inherit userConfig inputs pkgs lib helpers;})
    (import ./tools/default.nix {inherit pkgs userConfig lib config helpers inputs;})
    (import ./system/default.nix {inherit pkgs userConfig lib helpers;})
    (import ./hardware/default.nix {inherit userConfig lib helpers;})
    (import ./network/default.nix {inherit userConfig pkgs lib helpers;})
  ];

  home-manager.users = {
    "${username}" = {
      programs.home-manager.enable = true;
      home = {
        homeDirectory = "/home/${username}";
        username = "${username}";
        stateVersion = "23.11";
      };
    };
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    settings.auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users."${userConfig.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = ["wheel"];
    };
  };

  specialisation = {
    Hyprland.configuration = let
      wm = "Hyprland";
    in {
      imports = [
        (import ./environments/default.nix {inherit inputs pkgs wm userConfig;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      wm = "sway";
    in {
      imports = [
        (import ./environments/default.nix {inherit inputs pkgs wm userConfig;})
      ];
      environment.etc."specialisation".text = "sway";
    };
  };
}
