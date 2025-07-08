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
}
