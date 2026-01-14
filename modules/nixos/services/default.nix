{ profile, ... }:
{
  imports = [
    ./proton-vpn
    ./tailscale
    ./logind
    ./k3s
    ./gc
    ./sccache
    ./flatpak
    #./minio
  ];

  services = {
    udisks2.enable = profile == "desktop";
    gnome.gnome-keyring.enable = profile == "desktop";
    userborn.enable = true;
    orca.enable = false;
    speechd.enable = false;
    fail2ban = {
      #enable = profile == "server";
      maxretry = 5;
      ignoreIP = [
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        maxtime = "168h";
        overalljails = true;
      };
    };
    #endlessh = {
    #  enable = profile == "server";
    #  port = 22;
    #  openFirewall = true;
    #};
  };
}
