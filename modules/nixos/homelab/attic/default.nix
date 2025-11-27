{ lib, ... }:
{
  imports = [ ];

  options.homelab.attic = {
    enable = lib.mkEnableOption "attic";
  };
}
