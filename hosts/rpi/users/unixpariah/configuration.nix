{ pkgs, config, ... }:
{
  sops.secrets = {
    github-api = { };
  };

  programs = {
    tmux.enable = true;
    git = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  home.packages = with pkgs; [
    lazygit
    unzip
    gh
  ];
}
