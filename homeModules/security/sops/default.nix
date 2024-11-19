{
  std,
  pkgs,
  username,
  hostname,
  ...
}:
{
  config = {
    impermanence.persist.directories = [ ".config/sops/age" ];
    sops = {
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
