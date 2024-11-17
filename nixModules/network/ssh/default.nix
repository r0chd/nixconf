{ std, username, config, lib, pkgs, ... }:
let
  keysDir = "${std.dirs.host}/keys";
  keysList = if (builtins.pathExists keysDir) then
    (builtins.attrValues (builtins.mapAttrs
      (fileName: fileType: (builtins.readFile "${keysDir}/${fileName}"))
      (builtins.readDir keysDir)))
  else
    [ ];
in {
  users.users."${username}".openssh.authorizedKeys.keys = keysList;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    extraConfig = lib.mkIf config.yubikey.enable "AddKeysToAgent yes";
  };

  security.pam.services.sudo = lib.mkIf config.yubikey.enable {
    rules.auth.rssh = { order = config.rules.auth.ssh_agent_auth.order - 1; };
    control = "sufficient";
    modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
    settings.authorized_keys_command =
      pkgs.writeShellScript "get-authorized-keys"
      "cat ~/etc/ssh/authorized_keys.d/$1";
  };
}
