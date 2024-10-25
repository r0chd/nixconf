{
  hostname,
  pkgs,
}: {
  networking = {
    wireless.iwd = {
      enable = true;
    };
    hostName = "${hostname}";
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
    traceroute
    inetutils
  ];
}
