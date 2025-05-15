{ pkgs, config, ... }:
{
  sops.secrets = {
    github-api = { };
  };

  programs = {
    tmux.enable = true;
    git.signingKey = {
      enable = true;
      file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  email = "100892812+unixpariah@users.noreply.github.com";

  home.packages = with pkgs; [
    lazygit
    unzip
    gh
  ];
}
