{ config, pkgs, ... }:
{
  sops.secrets = {
    "atuin/DB_PASSWORD" = { };
    "atuin/DB_URI" = { };
  };

  security.yubikey = {
    enable = true;
    rootAuth = true;
    id = "31888351";
    actions = {
      unplug.enable = true;
      plug.enable = true;
    };
  };

  homelab = {
    enable = true;
    atuin = {
      enable = true;
      db = {
        username = "atuin";
        passwordFile = config.sops.secrets."atuin/DB_PASSWORD".path;
        uriFile = config.sops.secrets."atuin/DB_URI".path;
        storageSize = "1Gi";
        resources = {
          requests = {
            cpu = "100m";
            memory = "256Mi";
          };
          limits = {
            cpu = null;
            memory = "512Mi";
          };
        };
      };
    };
  };

  environment = {
    systemPackages = builtins.attrValues { inherit (pkgs) pamtester; };

    etc = {
      "pam.d/hyprlock".text = ''
        auth include login
      '';
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
}
