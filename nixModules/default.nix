{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (config) username browser term shell;
in {
  imports = [
    (import ./environments/wayland/default.nix {inherit inputs pkgs;})
    (import ./security/default.nix {inherit inputs username;})
    (import ./gui/default.nix {inherit inputs username pkgs browser;})
    (import ./tools/default.nix {inherit config pkgs inputs;})
    (import ./system/default.nix {inherit pkgs config lib inputs;})
    (import ./hardware/default.nix {inherit config;})
    (import ./network/default.nix {inherit config pkgs;})
    (import ./home.nix {inherit config;})
  ];

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
    gcc
    alejandra
    nil
  ];

  specialisation = {
    Hyprland.configuration = {
      imports = [
        (import ./environments/wayland/hyprland/default.nix {inherit inputs pkgs username term shell;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = {
      services.xserver.videoDrivers = ["nouveau"];
      imports = [
        (import ./environments/wayland/sway/default.nix {inherit inputs pkgs username term shell;})
      ];
      environment.etc."specialisation".text = "Sway";
    };
  };
}
