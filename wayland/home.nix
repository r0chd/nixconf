{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/fish.nix
    ./configs/hyprland.nix
  ];
}
