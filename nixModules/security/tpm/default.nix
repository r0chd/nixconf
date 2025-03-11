{
  pkgs,
  lib,
  systemUsers,
  ...
}:
{
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  users.users =
    systemUsers
    |> lib.mapAttrs (
      name: value: {
        extraGroups = lib.mkIf value.root.enable [
          "tss"
        ];
      }
    );

  environment.systemPackages = with pkgs; [
    tpm2-tss
    (writeShellApplication {
      name = "apply-tpm";
      runtimeInputs = with pkgs; [
        cryptsetup
        systemd
      ];
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
}
