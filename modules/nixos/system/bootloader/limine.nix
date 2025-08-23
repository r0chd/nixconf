{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.limine = lib.mkIf (cfg.variant == "limine") {
    enable = true;
    editor = true;
  };
}
