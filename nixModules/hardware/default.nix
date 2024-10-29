{ conf, lib, pkgs }: {
  imports = [
    (import ./audio { inherit conf lib pkgs; })
    (import ./bluetooth { inherit conf lib; })
    (import ./power { inherit conf lib; })
  ];

  hardware.enableAllFirmware = true;
}
