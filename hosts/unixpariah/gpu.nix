{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.52.04";
        sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
        sha256_aarch64 = lib.fakeSha256;
        openSha256 = lib.fakeSha256;
        settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
        persistencedSha256 = lib.fakeSha256;
      };
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:0:1:0";
      };
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nvidia" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec $@
    '')
  ];
}
