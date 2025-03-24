{ username, config, ... }:
{
  services.ssh-agent.enable = true;
  sops.secrets."${username}/ssh" = { };
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";

    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = {
      "git" = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_yubikey" ] ++ [ config.sops.secrets."${username}/ssh".path ];
      };
    };
  };

  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  };
}
