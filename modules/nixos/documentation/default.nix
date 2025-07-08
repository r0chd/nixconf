{ config, lib, ... }:
let
  cfg = config.documentation;
in
{
  documentation = {
    enable = lib.mkDefault false;
    doc.enable = lib.mkDefault cfg.enable;
    info.enable = lib.mkDefault cfg.enable;
    man = {
      enable = lib.mkDefault cfg.enable;
      generateCaches = lib.mkDefault cfg.man.enable;
    };
    dev.enable = lib.mkDefault cfg.enable;
  };
}
