{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;

    matchBlocks."*" = {
      hashKnownHosts = true;
      addKeysToAgent = "yes";
      userKnownHostsFile = lib.mkIf config.services.impermanence.enable "~/.ssh/custom_known_hosts/known_hosts";

      controlMaster = "auto";
      controlPath = "~/.ssh/sockets/S.%r@%h:%p";
      controlPersist = "10m";
    };
  };

  systemd.user.services.derive-public-keys = {
    Unit = {
      Description = "Derive public keys from private SSH keys";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "derive-public-keys" ''
        for file in ~/.ssh/id_*; do
          if [[ ! "$file" =~ \.pub$ ]]; then
            pubfile="''${file}.pub"
            if [[ ! -f "$pubfile" ]]; then
              ${pkgs.openssh}/bin/ssh-keygen -y -f $file > "$pubfile"
              chmod 600 "$pubfile"
            fi
          fi
        done
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home = {
    persist.directories = [ ".ssh/custom_known_hosts" ];
    file = {
      ".ssh/config.d/.keep".text = "# Managed by Home Manager";
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    };
  };
}
