{ profile, ... }:
{
  imports = [
    ./vesktop
    ./cachix
    ./shell
    ./editor
    ./multiplexer
    ./zoxide
    ./bat
    ./direnv
    ./btop
    ./obs
    ./keepassxc
    ./browser
    ./starship
    ./fastfetch
    ./atuin
    ./nh
    ./gcloud
    ./vcs
    ./minio
    ./re-toolkit
  ];

  programs = {
    moxctl.enable = profile == "desktop";
  };

  nix.settings = {
    substituters = [ "https://moxctl.cachix.org" ];
    trusted-substituters = [ "https://moxctl.cachix.org" ];
    trusted-public-keys = [ "moxctl.cachix.org-1:vt1+ClGngDYncy+eBCGI88dieEbfvX5GHnKBaTvLBPw=" ];
  };
}
