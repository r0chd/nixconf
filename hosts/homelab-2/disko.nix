{
  disko.devices = {
    disk.main = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          ESP = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted-main";
              extraOpenArgs = [ ];
              passwordFile = "/tmp/secret.key";
              settings = {
                allowDiscards = true;
                crypttabExtraOpts = [
                  "fido2-device=auto"
                  "token-timeout=10"
                ];
              };
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "pquota"
              ];
            };
          };
        };
      };
    };
  };
}
