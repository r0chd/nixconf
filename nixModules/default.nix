{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (config) username;
in {
  imports = [
    (import ./environments/wayland/default.nix {inherit inputs pkgs;})
    (import ./security/default.nix {inherit inputs config;})
    (import ./gui/default.nix {inherit config inputs pkgs;})
    (import ./tools/default.nix {inherit pkgs inputs config;})
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
    initialPassword = "root";
    extraGroups = ["wheel"];
  };

  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  specialisation = {
    Hyprland.configuration = {
      imports = [
        (import ./environments/wayland/hyprland/default.nix {inherit inputs pkgs config;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = {
      services.xserver.videoDrivers = ["nouveau"];
      imports = [
        (import ./environments/wayland/sway/default.nix {inherit inputs pkgs config;})
      ];
      environment.etc."specialisation".text = "Sway";
    };
  };
}
