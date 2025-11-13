{ ... }:
{
  #boot.initrd = {
  #  availableKernelModules = [ "r8169" ];
  #  systemd = {
  #    enable = true;
  #    network = {
  #      networks = {
  #        "enp1s0" = {
  #          matchConfig = {
  #            Name = "enp1s0";
  #          };
  #          networkConfig = {
  #            DHCP = "yes";
  #          };
  #        };
  #      };
  #    };
  #    services = {
  #      zfs-initrd-unlock = {
  #        description = "Unlock ZFS pools in initrd";
  #        after = [
  #          "network-online.target"
  #          "sshd.service"
  #        ];
  #        serviceConfig = {
  #          Type = "oneshot";
  #          RemainAfterExit = true;
  #        };
  #        script = ''
  #          cat <<EOF > /root/.profile
  #          if pgrep -x "zfs" > /dev/null
  #          then
  #            zpool import -a
  #            zfs load-key -a
  #            killall zfs
  #          else
  #            echo "zfs not running -- maybe the pool is taking some time to load for some unforseen reason."
  #          fi
  #          EOF
  #        '';
  #        wantedBy = [ "initrd.target" ];
  #      };
  #    };
  #    network = {
  #      enable = true;
  #    };
  #  };
  #  network = {
  #    enable = true;
  #    ssh = {
  #      enable = true;
  #      port = 2222;
  #      hostKeys = [
  #        /boot/ssh_host_rsa_key
  #        /boot/ssh_host_ed25519_key
  #      ];

  #      ignoreEmptyHostKeys = true;
  #    };
  #  };
  #};

  services.openssh = {
    enable = true;
    settings = {
      AuthenticationMethods = "publickey";
      PermitRootLogin = "prohibit-password";
    };
  };

  environment.persist.directories = [
    {
      directory = "/root/.ssh";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];
}
