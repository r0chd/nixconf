{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.hardware.rpi;
in
{
  options.hardware.rpi.enable = lib.mkEnableOption "raspberry pi";

  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    ./sd-image
  ];

  config = lib.mkIf cfg.enable {
    raspberry-pi-nix = {
      enable = true;
      board = "bcm2712";
      uboot.enable = false;
      libcamera-overlay.enable = false;
    };

    hardware.raspberry-pi.config = {
      pi5.dt-overlays.vc4-kms-v3d-pi5 = {
        enable = true;
        params = { };
      };
      all.base-dt-params.krnbt = {
        enable = true;
        value = "on";
      };
    };
  };
}
