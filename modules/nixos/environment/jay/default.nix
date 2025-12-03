{ lib, profile, ... }:
{
  options.programs.jay = {
    enable = lib.mkOption {
      enable = true;
      default = profile == "desktop";
    };
  };
}
