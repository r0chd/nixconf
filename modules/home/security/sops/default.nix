{
  pkgs,
  config,
  inputs,
  lib,
  platform,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  systemd.user.services.sops-generate-key = lib.mkIf (platform == "non-nixos") {
    Unit.Description = "Generate SOPS age keys from SSH keys";

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScriptBin "sops-generate-key" ''
        mkdir -p "$(dirname "${config.home.homeDirectory}/.config/sops/age/keys.txt")"
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "${config.home.homeDirectory}/.ssh/id_ed25519" > "${config.home.homeDirectory}/.config/sops/age/keys.txt"
      ''}/bin/sops-generate-key";
    };
  };

  sops = {
    secrets = lib.mkIf (platform != "non-nixos") {
      "${config.home.username}/ssh" = { };
      "${config.home.username}/password" = { };
    };
    defaultSopsFile = ../../../../hosts/${config.networking.hostName}/users/${config.home.username}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
  home = {
    shellAliases.opensops = "sops /var/lib/nixconf/hosts/${config.networking.hostName}/users/${config.home.username}/secrets/secrets.yaml";
    packages = [ pkgs.sops ];
  };
}
