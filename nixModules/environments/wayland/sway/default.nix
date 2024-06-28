{
  inputs,
  config,
  ...
}: let
  inherit (config) username terminal colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit inputs username terminal colorscheme browser;})
  ];

  security.polkit.enable = true;
}
