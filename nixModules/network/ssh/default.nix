{
  hostname,
  username,
  lib,
}: let
  keysDir = ../../../hosts/${hostname}/keys;
  keysList =
    if (builtins.pathExists keysDir)
    then
      (builtins.attrValues (builtins.mapAttrs (fileName: fileType: (builtins.readFile "${keysDir}/${fileName}"))
          (builtins.readDir keysDir)))
    else [];
in {
  users.users."${username}".openssh.authorizedKeys.keys = keysList;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
