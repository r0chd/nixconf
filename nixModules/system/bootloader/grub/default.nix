_: {
  boot.loader = {
      timeout = null;
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = false;
        useOSProber = true;
      };
  };
}
