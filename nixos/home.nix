{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/kitty.nix
  ];

  home.username = "unixpariah";
  home.homeDirectory = "/home/unixpariah";

  home.stateVersion = "23.11";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "unixpariah";
    userEmail = "oskar.rochowiak@tutanota.com";
  };

  programs.home-manager.enable = true;
}
