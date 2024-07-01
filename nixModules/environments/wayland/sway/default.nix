{
  inputs,
  config,
  pkgs,
}: let
  inherit (config) username terminal colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit inputs username terminal colorscheme browser pkgs;})
  ];

  security.polkit.enable = true;
}
