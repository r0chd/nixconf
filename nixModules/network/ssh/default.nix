{username}: let
  keysDir = ../../../hosts/${username}/keys;
  keysList =
    if builtins.pathExists keysDir
    then
      builtins.attrValues (builtins.mapAttrs (fileName: fileType:
        builtins.trace "Processing file: ${fileName}" (builtins.readFile "${keysDir}/${fileName}"))
      (builtins.readDir keysDir))
    else [];
in {
  users.users."${username}".openssh.authorizedKeys.keys = keysList;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
