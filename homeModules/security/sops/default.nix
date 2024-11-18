{
  std,
  lib,
  config,
  pkgs,
  username,
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
      defaultSopsFile = "${std.dirs.host}/users/${username}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "${std.dirs.home-persist}/.ssh/id_ed25519" ];
        keyFile = "${std.dirs.home-persist}/.config/sops/age/keys.txt";
      };
    };
    home = {
      shellAliases.opensops = "sops ${std.dirs.host}/users/${username}/secrets/secrets.yaml";
      packages = with pkgs; [ sops ];
    };
  };
}
