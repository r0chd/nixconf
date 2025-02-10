{ lib, ... }:
{
  programs.sway = {
    enable = lib.mkDefault true;
    extraOptions = [ "--unsupported-gpu" ];
  };
}
