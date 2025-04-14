{ pkgs, config, ... }:
{
  sops.secrets = {
    nixos-access-token-github = { };
    "klocki/jwt_secret" = { };
    "klocki/master_password" = { };
    "klocki/db_password" = { };
  };

  programs = {
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  systemd.user.services.eclipse = {
    Service = {
      ExecStart = "/home/unixpariah/.cargo/bin/bitz collect";
      Restart = "on-failure";
      RestartSec = "1sec";
    };
  };

  email = "oskar.rochowiak@tutanota.com";

  home.packages = with pkgs; [
    bitz
    solana-cli
    lazygit
    unzip
  ];
}
