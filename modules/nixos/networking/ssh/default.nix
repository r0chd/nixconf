_: {
  boot.initrd.network.ssh = {
    enable = true;
    ignoreEmptyHostKeys = true;
  };

  #security.pam = {
  #  sshAgentAuth.enable = true;
  #  services.sudo.sshAgentAuth = true;
  #};

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
      extraConfig = ''
        AuthenticationMethods publickey
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
