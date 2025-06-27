{ config, pkgs, ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    addKeysToAgent = "yes";
    userKnownHostsFile = "~/.ssh/known_hosts/default";

    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";
  };

  home = {
    persist.directories = [ ".ssh/known_hosts" ];
    file = {
      ".ssh/config.d/.keep".text = "# Managed by Home Manager";
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    };
    activation.derivePublicKeys = ''
      for file in ~/.ssh/id_*; do
        if [[ ! "$file" =~ \.pub$ ]]; then
          pubfile="''${file}.pub"
          if [[ ! -f "$pubfile" ]]; then
            ${pkgs.openssh}/bin/ssh-keygen -y -f $file > "$pubfile"
            ${pkgs.uutils-coreutils-noprefix}/bin/chmod 600 "$pubfile"
          fi
        fi
      done
    '';

  };
}
