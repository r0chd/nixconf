{
  hostname,
  pkgs,
  ...
}: {
  networking = {
    wireless.iwd.enable = true;
    hostName = "${hostname}";
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
