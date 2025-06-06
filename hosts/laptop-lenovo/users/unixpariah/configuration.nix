{ pkgs, config, ... }:
{
  sops.secrets.nixos-access-token-github = { };

  programs = {
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
    git.email = "100892812+unixpariah@users.noreply.github.com";
  };

  services.impermanence.enable = true;

  home.packages = with pkgs; [
    lazygit
    unzip
  ];
}
