{ profile, ... }:
{
  imports = [
    ./proton-vpn
    ./tailscale
    ./logind
    ./k3s
    ./gc
    ./sccache
  ];

  services = {
    udisks2.enable = profile == "desktop";
    gnome.gnome-keyring.enable = profile == "desktop";
    userborn.enable = true;
  };
}
