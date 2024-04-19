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

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland
    obs-studio
    (let
      pkg = import (fetchTarball {
        url = "https://github.com/unixpariah/ssb/archive/main.tar.gz";
      }) {};
    in
      pkg.overrideAttrs (oldAttrs: {
        buildInputs =
          oldAttrs.buildInputs
          ++ [libpulseaudio];
      }))
  ];
}
