{
  pkgs,
  inputs,
  username,
  shell,
  ...
}: {
  imports = [
    (import ./configs/home.nix {inherit inputs username;})
    (
      if shell == "fish"
      then ./configs/fish.nix
      else if shell == "zsh"
      then ./configs/zsh.nix
      else ./configs/bash.nix
    )
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    hyprcursor
  ];
}
