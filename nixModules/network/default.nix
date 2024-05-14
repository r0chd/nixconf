{pkgs, ...}: {
  networking = {
    wireless.iwd.enable = true;
    hostName = "laptop";
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
