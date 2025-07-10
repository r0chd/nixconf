{ profile, inputs, ... }:
{
  imports = [
    ./nixcord
    ./cachix
    ./git
    ./shell
    ./editor
    ./multiplexer
    ./zoxide
    ./bat
    ./direnv
    ./seto
    ./btop
    ./obs
    ./keepassxc
    ./browser
    ./starship
    ./fastfetch
    ./atuin
    ./nh
    ./gcloud
    inputs.moxctl.homeManagerModules.default
  ];

  programs = {
    moxctl.enable = profile == "desktop";
    home-manager.enable = true;
  };

  nix.settings = {
    substituters = [ "https://moxctl.cachix.org" ];
    trusted-substituters = [ "https://moxctl.cachix.org" ];
    trusted-public-keys = [ "moxctl.cachix.org-1:vt1+ClGngDYncy+eBCGI88dieEbfvX5GHnKBaTvLBPw=" ];
  };
}
