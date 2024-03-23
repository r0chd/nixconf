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
    (import (fetchGit {
      url = "https://github.com/unixpariah/ssb.git";
      ref = "main";
      rev = "47d18f3ef63770f7dce90c7158a1f22cc259dada";
    }) {})
  ];
}
