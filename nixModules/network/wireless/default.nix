{
  hostname,
  pkgs,
  ...
}: {
  networking = {
    wireless.iwd.enable = true;
    hostName = "${hostname}";
    nameservers = ["1.1.1.1"];
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
