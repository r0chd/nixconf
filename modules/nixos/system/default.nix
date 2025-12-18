{ ... }:
{
  imports = [
    ./bootloader
    ./impermanence
    ./displayManager
  ];

  config.system = {
    nixos-init.enable = true;
    disableInstallerTools = true;
    etc.overlay = {
      enable = true;
      #mutable = false;
    };

    # Unfortunatelly slows down nixos-rebuild A LOT
    #includeBuildDependencies = true;

    stateVersion = "25.11";
  };
}
