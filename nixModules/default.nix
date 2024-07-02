{
  userConfig,
  pkgs,
  inputs,
  lib,
  config,
}: let
  inherit (userConfig) username;
in {
  imports = [
    (import ./security/default.nix {inherit inputs userConfig pkgs;})
    (import ./gui/default.nix {inherit userConfig inputs pkgs;})
    (import ./tools/default.nix {inherit pkgs userConfig;})
    (import ./system/default.nix {inherit pkgs userConfig lib inputs;})
    (import ./hardware/default.nix {inherit userConfig;})
    (import ./network/default.nix {inherit userConfig pkgs;})
  ];

  home-manager.users."${username}" = {
    home = {
      homeDirectory = "/home/${username}";
      username = "${username}";
      stateVersion = "23.11";
    };
    programs = {
      home-manager.enable = true;
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  sops.secrets.password.neededForUsers = true;

  users = {
    mutableUsers = false;
    users."${userConfig.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = ["wheel"];
    };
  };

  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    inputs.ruin.packages.${system}.default
    man-pages
    man-pages-posix
  ];

  specialisation = {
    Hyprland.configuration = let
      wm = "Hyprland";
    in {
      imports = [
        (import ./environments/wayland/default.nix {inherit inputs pkgs wm userConfig;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      wm = "sway";
    in {
      imports = [
        (import ./environments/wayland/default.nix {inherit inputs pkgs wm userConfig;})
      ];
      environment.etc."specialisation".text = "sway";
    };
    i3.configuration = let
      wm = "i3";
    in {
      imports = [
        (import ./environments/x11/default.nix {inherit inputs pkgs wm userConfig;})
      ];
      environment.etc."specialisation".text = "i3";
    };
  };
}
