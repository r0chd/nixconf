{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    users."${username}" = import ../../../../home/wayland/hyprland/home.nix;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    hyprcursor
  ];
}
