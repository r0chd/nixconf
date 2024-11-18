{
  std,
  lib,
  config,
  pkgs,
  username,
  hostname,
  ...
}:
{
  options.sops = {
    enable = lib.mkEnableOption "Enable sops";
    managePassword = lib.mkEnableOption "Manage password with sops";
  };

  config = lib.mkIf config.sops.enable {
    impermanence.persist.directories = [ ".config/sops/age" ];
    sops = {
      secrets."yubico/u2f_keys" = {
        path = "/home/unixpariah/.config/Yubico/u2f_keys";
      };
      defaultSopsFile = "${std.dirs.host}/users/${username}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "${std.dirs.home}/.ssh/id_ed25519" ];
        keyFile = "${std.dirs.home}/.config/sops/age/keys.txt";
      };
    };
    home = {
      shellAliases.opensops = "sops ${std.dirs.config}/hosts/${hostname}/users/${username}/secrets/secrets.yaml";
      packages = with pkgs; [ sops ];
    };
  };
}
