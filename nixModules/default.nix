{
  userConfig,
  pkgs,
  inputs,
  lib,
  config,
  hostname,
  ...
}: let
  inherit (userConfig) username;
  std = import ./std/default.nix {inherit username;};
  conf =
    lib.recursiveUpdate (import ./default_config.nix {
      inherit hostname;
      disableAll = userConfig ? disableAll && userConfig.disableAll == true;
    })
    userConfig;
in {
  imports = [
    (import ./security/default.nix {inherit conf inputs pkgs std;})
    (import ./gui/default.nix {inherit conf inputs pkgs lib;})
    (import ./tools/default.nix {inherit conf pkgs lib config std inputs;})
    (import ./system/default.nix {inherit conf pkgs lib std;})
    (import ./hardware/default.nix {inherit conf lib std;})
    (import ./network/default.nix {inherit conf pkgs lib std;})
  ];

  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    home = {
      homeDirectory = std.home;
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
        (import ./environments/default.nix {inherit conf inputs pkgs wm lib std;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      wm = "sway";
    in {
      imports = [
        (import ./environments/default.nix {inherit conf inputs pkgs wm lib std;})
      ];
      environment.etc."specialisation".text = "sway";
    };
  };
}
