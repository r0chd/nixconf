{
  pkgs,
  lib,
  systemUsers,
  config,
  ...
}:
{
  config = lib.mkIf config.security.tpm2.enable {
    security.tpm2 = {
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    users.users =
      systemUsers |> lib.mapAttrs (name: value: { extraGroups = lib.mkIf value.root.enable [ "tss" ]; });

    boot.initrd = {
      kernelModules = [ "tpm_crb" ];
      systemd = {
        tpm2.enable = true;
        contents = {
          "/etc/fstab".text = ''
            /dev/mapper/tpm2bag /tpm2bag ext4 defaults 0 2
            /tpm2bag/var/lib/tailscale /var/lib/tailscale none bind,x-systemd.requires-mounts-for=/tpm2bag/var/lib/tailscale
            # nofail so it doesn't order before local-fs.target and therefore systemd-tmpfiles-setup
            /dev/mapper/keybag /keybag ext4 defaults,nofail,x-systemd.device-timeout=0,ro 0 2
          '';
          "/etc/tmpfiles.d/50-ssh-host-keys.conf".text = ''
            C /etc/ssh/ssh_host_ed25519_key 0600 - - - /tpm2bag/etc/ssh/ssh_host_ed25519_key
            C /etc/ssh/ssh_host_rsa_key 0600 - - - /tpm2bag/etc/ssh/ssh_host_rsa_key
          '';
        };
      };
    };

    environment.systemPackages = [
      pkgs.tpm2-tss
      (pkgs.writeShellApplication {
        name = "apply-tpm";
        runtimeInputs = builtins.attrValues { inherit (pkgs) cryptsetup systemd; };
        text = ''
          #!/usr/bin/env bash
          ## Writes the LUKS key to the TPM with preset PCRs 0+2+7
          ## If no disk specified, tries to auto-find LUKS devices

          PCRS="''${OVERRIDE_PCRS:-0+2+7}"

          function usage() {
            >&2 echo "Usage: $0 [LUKS partition]"
            exit 1
          }

          if [ "$#" -eq 0 ]; then
            partuuid="$(lsblk -o fstype,uuid | awk '/crypto_LUKS/{print $2; exit}')"
            lukspath="$(readlink -f "/dev/disk/by-uuid/$partuuid")"
          elif [ -b "$1" ]; then
            lukspath="$1"
          else
            usage
          fi

          if ! cryptsetup isLuks -v "$lukspath"; then
            >&2 echo "Invalid LUKS partition: $lukspath"
            usage
          fi

          echo "Using LUKS partition: $lukspath"
          echo "Selected PCRs: $PCRS"
          echo

          exec systemd-cryptenroll "$lukspath" \
              --wipe-slot=tpm2 \
              --tpm2-device=auto \
              --tpm2-pcrs="$PCRS"
        '';
      })
    ];

  };
}
