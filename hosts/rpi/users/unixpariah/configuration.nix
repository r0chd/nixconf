{
  pkgs,
  lib,
  config,
  ...
}:
{
  sops.secrets.nixos-access-token-github = { };

  programs = {
    nh.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  email = "oskar.rochowiak@tutanota.com";

  home.packages = with pkgs; [
      lazygit
      unzip
  ];
}
