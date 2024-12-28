{ lib, ... }:
{
  options.environment.launcher = {
    enable = lib.mkEnableOption "Enable launcher";
    program = lib.mkOption { type = lib.types.enum [ "fuzzel" ]; };
  };

  imports = [ ./fuzzel ];
}
