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
      rev = "a9f83a1564186516f9e5e19ef0515f422618b46d";
    }) {})
  ];
}
