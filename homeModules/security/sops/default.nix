{
  std,
  pkgs,
  username,
  config,
  ...
}:
{
  config = {
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
      shellAliases.opensops = "sops ${config.sops.defaultSopsFile}";
      packages = with pkgs; [ sops ];
    };
  };
}
