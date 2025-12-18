{ ... }:
{
  imports = [
    ./wireless
    ./ssh
  ];

  boot.initrd.services.resolved.enable = true;

  services.resolved = {
    enable = true;
  };
}
