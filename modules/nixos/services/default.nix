{ profile, ... }:
{
  imports = [
    ./proton-vpn
    ./tailscale
    ./logind
    ./phpApp
    ./k3s
    ./gc
  ];

  services = {
    udisks2.enable = profile == "desktop";
    gnome.gnome-keyring.enable = profile == "desktop";
    userborn.enable = false;
  };
}
