{
  term,
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    (import ./home.nix {inherit inputs username term;})
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
