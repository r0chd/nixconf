{ profile, ... }:
{
  imports = [
    ./proton-vpn
    ./tailscale
    ./logind
    ./k3s
    ./gc
    ./sccache
    #./minio
  ];

  services = {
    udisks2.enable = profile == "desktop";
    gnome.gnome-keyring.enable = profile == "desktop";
    userborn.enable = true;
    orca.enable = false;
    speechd.enable = false;
  };
}
