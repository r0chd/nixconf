{
  std,
  config,
  lib,
  ...
}:
{
  users.users = lib.genAttrs (builtins.attrNames config.systemUsers) (
    user:
    let
      keysDir = "${std.dirs.host}/users/${user}/keys";
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

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
