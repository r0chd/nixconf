{ ... }:
{
  imports = [
    ./wireless
    ./ssh
  ];

  boot.initrd = {
    network.enable = true;
    availableKernelModules = [ "alx" ];
    kernelModules = [
      "vfat"
      "nls_cp437"
      "nls_iso8859-1"
      "usbhid"
      "alx"
    ];
  };
}
