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

  security.polkit.enable = true;
}
