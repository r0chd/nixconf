{
  userConfig,
  pkgs,
  inputs,
  lib,
  config,
}: let
  inherit (userConfig) username;
  helpers = {
    checkAttribute = attribute: opt: !helpers.disableAll && lib.hasAttr attribute userConfig && userConfig.${attribute} == "${opt}";
    disableAll = lib.hasAttr "disableAll" userConfig && userConfig.disableAll == true;
    isDisabled = attribute: helpers.disableAll || (lib.hasAttr attribute userConfig && userConfig.${attribute} == false);
    isEnabled = attribute: !helpers.disableAll && lib.hasAttr attribute userConfig && userConfig.${attribute} == true;
  };
in {
  imports = [
    (import ./security/default.nix {inherit inputs userConfig pkgs;})
    (import ./gui/default.nix {inherit userConfig inputs pkgs lib helpers;})
    (import ./tools/default.nix {inherit pkgs userConfig lib config helpers;})
    (import ./system/default.nix {inherit pkgs userConfig lib helpers;})
    (import ./hardware/default.nix {inherit userConfig lib helpers;})
    (import ./network/default.nix {inherit userConfig pkgs lib helpers;})
  ];

  home-manager.users."${username}" = {
    programs.home-manager.enable = true;
    home = {
      homeDirectory = "/home/${username}";
      username = "${username}";
      stateVersion = "23.11";
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
    (writeShellScriptBin "opensops" ''
      sops "$FLAKE/hosts/${username}/secrets/secrets.yaml"
    '')
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
