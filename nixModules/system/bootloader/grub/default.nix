{ conf, lib }: {
  config = lib.mkIf (conf.boot.program == "grub") {
    boot.loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
}
