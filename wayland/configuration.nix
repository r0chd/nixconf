{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ./home.nix;};
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    wl-clipboard
    hyprcursor
    wayland
    obs-studio
    (let
      pkg = import (fetchTarball {
        url = "https://github.com/unixpariah/ssb/archive/main.tar.gz";
        sha256 = "02cx9n5yb1c694b8xyw412sxxv5r5yb05p21rk0pzldi0y7b6ri4";
      }) {};
    in
      pkg.overrideAttrs (oldAttrs: {
        buildInputs =
          oldAttrs.buildInputs
          ++ [libpulseaudio];
      }))
  ];
}
