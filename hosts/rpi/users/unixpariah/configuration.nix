{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "ngrok" ];

  sops.secrets = {
    nixos-access-token-github = { };
    ngrok = { };
    "klocki/jwt_secret" = { };
    "klocki/master_password" = { };
    "klocki/db_password" = { };
  };

  programs = {
    fastfetch.enable = true;
    nh.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    editor = "hx";
  };

  services.ngrok = {
    enable = true;
    agent.authtoken = config.sops.placeholder.ngrok;
  };

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  email = "oskar.rochowiak@tutanota.com";

  home.packages = with pkgs; [
    lazygit
    unzip
  ];
}
