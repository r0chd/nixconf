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

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    wl-clipboard
    wayland
    obs-studio
    (let
      pkg = import (fetchTarball {
        url = "https://github.com/unixpariah/ssb/archive/master.tar.gz";
      }) {};
    in
      pkg.overrideAttrs (oldAttrs: {
        buildInputs =
          oldAttrs.buildInputs
          ++ [libpulseaudio];
      }))
  ];
}
