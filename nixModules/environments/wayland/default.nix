{
  pkgs,
  inputs,
  wm,
  config,
}: let
  inherit (config) username colorscheme font;
in {
  imports = [
    (
      if wm == "Hyprland"
      then (import ./hyprland/default.nix {inherit inputs pkgs config;})
      else if wm == "Sway"
      then (import ./sway/default.nix {inherit inputs pkgs config wm;})
      else []
    )
    (import ./waystatus/default.nix {inherit username colorscheme font;})
  ];

  environment.shellAliases = {
    obs = "env -u WAYLAND_DISPLAY obs";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland
    obs-studio
    inputs.seto.packages.${system}.default
    inputs.waystatus.packages.${system}.default
  ];
}
