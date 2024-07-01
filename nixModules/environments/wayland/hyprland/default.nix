{
  pkgs,
  inputs,
  config,
}: let
  inherit (config) username terminal colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit inputs username terminal colorscheme browser pkgs;})
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
  ];
}
