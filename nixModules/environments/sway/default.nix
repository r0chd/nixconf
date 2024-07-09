{
  inputs,
  userConfig,
  pkgs,
}: let
  inherit (userConfig) username terminal colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit inputs username terminal colorscheme browser pkgs;})
  ];

  security.polkit.enable = true;
}
