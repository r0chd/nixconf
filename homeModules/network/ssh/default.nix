{ ... }:
{
  #services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;

    #controlMaster = "auto";
    #controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    #controlPersist = "10m";

    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = {
      "git" = {
        host = "github.com";
        user = "git";
        #forwardAgent = true;
        #identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_yubikey"
          "~/.ssh/id_ed25519"
        ];
      };
    };
  };

  # home.file = {
  #   ".ssh/config.d/.keep".text = "# Managed by Home Manager";
  #   ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  # };
}
