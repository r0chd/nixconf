{
  config,
  pkgs,
  inputs,
  lib,
}: let
  inherit (config) username password;
in {
  imports = [
    (import ./security/default.nix {inherit inputs config;})
    (import ./gui/default.nix {inherit config inputs pkgs;})
    (import ./tools/default.nix {inherit pkgs config;})
    (import ./system/default.nix {inherit pkgs config lib inputs;})
    (import ./hardware/default.nix {inherit config;})
    (import ./network/default.nix {inherit config pkgs;})
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

  users.users."${config.username}" = {
    isNormalUser = true;
    hashedPassword = "${password}";
    extraGroups = ["wheel"];
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
        (import ./environments/wayland/default.nix {inherit inputs pkgs wm config;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      wm = "sway";
    in {
      imports = [
        (import ./environments/wayland/default.nix {inherit inputs pkgs wm config;})
      ];
      environment.etc."specialisation".text = "sway";
    };
    i3.configuration = let
      wm = "i3";
    in {
      imports = [
        (import ./environments/x11/default.nix {inherit inputs pkgs wm config;})
      ];
      environment.etc."specialisation".text = "i3";
    };
  };
}
