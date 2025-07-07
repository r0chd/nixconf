{ ... }:
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
  ];

  programs.home-manager.enable = true;
}
