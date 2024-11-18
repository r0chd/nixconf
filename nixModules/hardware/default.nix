{ ... }:
{
  imports = [
    ./audio
    ./bluetooth
    ./power
  ];

  hardware.enableAllFirmware = true;
}
