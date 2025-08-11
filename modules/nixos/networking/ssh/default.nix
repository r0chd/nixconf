_:
{
  boot.initrd.network.ssh = {
    enable = true;
    ignoreEmptyHostKeys = true;
  };

  security.pam = {
    sshAgentAuth.enable = true;
    services.sudo.sshAgentAuth = true;
  };

  services = {
    openssh = {
      enable = true;
      allowSFTP = false;
      settings = {
        PasswordAuthentication = false;
        ChallengeResponseAuthentication = false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding yes
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
        PermitRootLogin no
        AcceptEnv *
        PermitUserEnvironment yes
      '';
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
