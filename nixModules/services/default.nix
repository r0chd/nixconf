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
  };

  # Replace users perl script with a RUST service
  #services.userborn.enable = true;
}
