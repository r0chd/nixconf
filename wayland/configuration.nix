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

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    wl-clipboard
    wayland
    (import (fetchGit {
      url = "https://github.com/unixpariah/ssb.git";
      ref = "main";
      rev = "09752908442fcaae69eeac3618ccc3396cb1746e";
    }) {})
  ];
}
