{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ../../../home/sway/home.nix;};
  };

  security.polkit.enable = true;
}
