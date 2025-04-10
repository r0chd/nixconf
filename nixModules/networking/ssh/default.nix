{
  lib,
  systemUsers,
  hostname,
  ...
}:
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
      '';
    };
  };

  users.users = lib.genAttrs (systemUsers |> builtins.attrNames) (
    user:
    let
      keysDir = ../../../hosts/${hostname}/users/${user}/keys;
      keyFiles = if (builtins.pathExists keysDir) then builtins.readDir keysDir else [ ];
      keysList =
        keyFiles
        |> builtins.mapAttrs (fileName: fileType: (builtins.readFile "${keysDir}/${fileName}"))
        |> builtins.attrValues;
    in
    {
      openssh.authorizedKeys.keys = keysList;
    }
  );

  environment.persist.directories = [
    {
      directory = "/root/.ssh";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];
}
