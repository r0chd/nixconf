{ ... }:
{
  imports = [
    ./audio
    ./bluetooth
    ./power
  ];

  hardware = {
    steam-hardware.enable = true;
    enableAllFirmware = true;
  };
}
