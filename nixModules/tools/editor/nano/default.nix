{ config, lib, ... }: {
  config = lib.mkIf (config.editor == "nano") { programs.nano.enable = true; };
}
