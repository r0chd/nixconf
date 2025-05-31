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

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  services.impermanence.enable = true;

  home.packages = with pkgs; [
    lazygit
    unzip
  ];
}
