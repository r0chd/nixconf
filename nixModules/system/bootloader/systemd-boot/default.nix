{ conf, lib }: {
  config = lib.mkIf (conf.boot.program == "systemd-boot") {
    boot.loader.systemd-boot.enable = true;
  };
}
