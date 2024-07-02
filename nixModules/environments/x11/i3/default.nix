{
  inputs,
  pkgs,
  userConfig,
}: let
  inherit (userConfig) username terminal colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit username terminal colorscheme browser pkgs;})
  ];

  environment.pathsToLink = ["/libexec"];

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    services.displayManager = {
      defaultSession = "none+i3";
    };
  };
}
