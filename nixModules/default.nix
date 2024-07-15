{
  userConfig,
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (userConfig) username;
  defaultConfig = import ./default_config.nix;
  helpers = {
    home = "/home/${username}";
  };
  conf = lib.recursiveUpdate defaultConfig userConfig;
in {
  imports = [
    (import ./security/default.nix {inherit conf inputs pkgs helpers;})
    (import ./gui/default.nix {inherit conf inputs pkgs lib helpers;})
    (import ./tools/default.nix {inherit conf pkgs lib config helpers inputs;})
    (import ./system/default.nix {inherit conf pkgs lib helpers;})
    (import ./hardware/default.nix {inherit conf lib helpers;})
    (import ./network/default.nix {inherit conf pkgs lib helpers;})
  ];

  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    home = {
      homeDirectory = helpers.home;
      username = "${username}";
      stateVersion = "24.05";
    };
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

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
        (import ./environments/default.nix {inherit conf inputs pkgs wm lib helpers;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      wm = "sway";
    in {
      imports = [
        (import ./environments/default.nix {inherit conf inputs pkgs wm lib helpers;})
      ];
      environment.etc."specialisation".text = "sway";
    };
  };
}
