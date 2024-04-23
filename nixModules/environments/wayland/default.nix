{
  inputs,
  pkgs,
  ...
}: let
  ssb = import (fetchTarball {
    url = "https://github.com/unixpariah/ssb/archive/main.tar.gz";
    sha256 = "0livq4vkvmwjarbaiyl9wd5xwj6m6hchijdx58pb3zrj6xbrw29g";
  }) {pkgs = pkgs;};
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  specialisation = {
    hyprland = {
      configuration = {
        imports = [
          ./hyprland/default.nix
        ];
      };
    };
    sway = {
      configuration = {
        services.xserver.videoDrivers = ["nouveau"];
        imports = [
          ./sway/default.nix
        ];
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ../../../home/wayland/home.nix;};
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland
    obs-studio
    ssb
  ];
}
