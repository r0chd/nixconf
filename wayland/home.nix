{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/fish.nix
    ./configs/waybar.nix
    ./configs/hyprland.nix
  ];
}
