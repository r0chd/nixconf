{pkgs, ...}: {
  networking = {
    wireless.iwd.enable = true;
    hostName = "nixos";
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
