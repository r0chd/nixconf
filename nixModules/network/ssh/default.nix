{
  username,
  lib,
}: let
  keysDir = ../../../hosts/${username}/keys;
  keysList =
    lib.optional (builtins.pathExists keysDir)
    (builtins.attrValues (builtins.mapAttrs (fileName: fileType:
      builtins.trace "Processing file: ${fileName}" (builtins.readFile "${keysDir}/${fileName}"))
    (builtins.readDir keysDir)));
in {
  users.users."${username}".openssh.authorizedKeys.keys = keysList;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
