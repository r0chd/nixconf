{
  pkgs,
  config,
  ...
}:
let
  home = (
    if config.impermanence.enable then
      "/persist/home/${config.home.username}"
    else
      "persist/home/${config.home.username}"
  );
  a = ../../../hosts/laptop;
in
{
  config = {
    impermanence.persist.directories = [ ".config/sops/age" ];
    sops = {
      defaultSopsFile = "${a}/users/${config.home.username}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "${home}/.ssh/id_ed25519" ];
        keyFile = "${home}/.config/sops/age/keys.txt";
      };
    };
    home = {
      shellAliases.opensops = "sops ${config.sops.defaultSopsFile}";
      packages = with pkgs; [ sops ];
    };
  };
}
