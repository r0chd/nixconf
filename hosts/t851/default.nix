{ pkgs, ... }:
{
  security.yubikey = {
    enable = true;
    rootAuth = true;
    id = "31888351";
    actions.unplug.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add",\
    ENV{SUBSYSTEM}=="usb",\
    ENV{PRODUCT}=="1050/407/571",\
    ATTR{serial}=="31888351",\
    RUN+="${pkgs.systemd}/bin/loginctl unlock-sessions"
  '';

  systemd.services.buildkitd = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    wants = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "buildkit";
      StateDirectory = "buildkit";
      RuntimeDirectory = "buildkit";
      ExecStart = "${pkgs.rootlesskit}/bin/rootlesskit ${pkgs.buildkit}/bin/buildkitd --rootless --addr unix:///run/buildkit/buildkitd.sock";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    path = builtins.attrValues { inherit (pkgs) shadow runc; };
  };

  environment = {
    etc = {
      "hosts".text = ''
        127.0.0.1 localhost
        127.0.1.1 t851

        # The following lines are desirable for IPv6 capable hosts
        ::1     ip6-localhost ip6-loopback
        fe00::0 ip6-localnet
        ff00::0 ip6-mcastprefix
        ff02::1 ip6-allnodes
        ff02::2 ip6-allrouters
      '';
      "gdm3/custom.conf".text = ''
        # GDM configuration storage
        #
        # See /usr/share/gdm/gdm.schemas for a list of available options.

        # Enabling automatic login

        # Enabling timed login
        #  TimedLoginEnable = true
        #  TimedLogin = user1
        #  TimedLoginDelay = 10

        [security]

        [xdmcp]

        [chooser]

        [debug]
        # Uncomment the line below to turn on debugging
        # More verbose logs
        # Additionally lets the X server dump core if it crashes
        #Enable=true
      '';
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
