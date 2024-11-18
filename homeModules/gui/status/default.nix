{ lib, ... }:
{
  options.statusBar = {
    enable = lib.mkEnableOption "Enable status bar";
    program = lib.mkOption { type = lib.types.enum [ "waystatus" ]; };
  };

  imports = [ ./waystatus ];
}
