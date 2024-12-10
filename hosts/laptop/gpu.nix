{ config, ... }:
{
  hardware = {
    steam-hardware.enable = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      open = true;
      nvidiaSettings = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:0:1:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
