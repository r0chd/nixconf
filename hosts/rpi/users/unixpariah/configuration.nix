{ pkgs, config, ... }:
{
  sops.secrets = {
    #"klocki/jwt_secret" = { };
    #"klocki/master_password" = { };
    #"klocki/db_password" = { };
  };

  programs = {
    git.signingKey = {
      enable = true;
      file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  email = "oskar.rochowiak@tutanota.com";

  home.packages = with pkgs; [
    lazygit
    unzip
  ];
}
