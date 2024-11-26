{
  pkgs,
  config,
  ...
}:
let
  host = ../../../hosts/laptop;
in
{
  config = {
    sops = {
      defaultSopsFile = "${host}/users/${config.home.username}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
        keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
      };
    };
    home = {
      shellAliases.opensops = "sops ${config.sops.defaultSopsFile}";
      packages = with pkgs; [ sops ];
    };
  };
}
