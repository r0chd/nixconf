{
  inputs,
  pkgs,
  config,
}: let
  inherit (config) username terminal colorscheme browser;
in {
  imports = [
    #(import ./home.nix {inherit username terminal colorscheme browser pkgs;})
  ];

  services.xserver = {
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
    };
  };
}
