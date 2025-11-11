{ ... }:
{
  imports = [
    ./bootloader
    ./impermanence
    ./displayManager
  ];

  config.system = {
    disableInstallerTools = true;
    etc.overlay = {
      #enable = true; // TODO: use it when its stabilized
      mutable = false;
    };
    # Unfortunatelly slows down nixos-rebuild A LOT
    #includeBuildDependencies = true;
    stateVersion = "25.11";
  };
}
