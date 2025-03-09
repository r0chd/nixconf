{
  lib,
  systemUsers,
  hostname,
  ...
}:
{
  services.openssh = {
    enable = true;
    allowSFTP = false;
    settings = {
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
    };
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
      PermitRootLogin no
    '';
  };

  users.users = lib.genAttrs (systemUsers |> builtins.attrNames) (
    user:
    let
      keysDir = ../../../hosts/${hostname}/users/${user}/keys;
      keysList =
        if (builtins.pathExists keysDir) then
          builtins.readDir keysDir
          |> builtins.mapAttrs (fileName: fileType: (builtins.readFile "${keysDir}/${fileName}"))
          |> builtins.attrValues
        else
          [ ];
    in
    {
      openssh.authorizedKeys.keys = keysList;
    }
  );

  system.impermanence.persist.directories = [
    {
      directory = "/root/.ssh";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];
}
