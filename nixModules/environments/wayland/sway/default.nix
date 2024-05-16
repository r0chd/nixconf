{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users."${username}" = import ../../../../home/wayland/sway/home.nix;

  security.polkit.enable = true;
}
