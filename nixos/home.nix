{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/kitty.nix
    ./configs/git.nix
    ./configs/qutebrowser.nix
  ];

  home.username = "unixpariah";
  home.homeDirectory = "/home/unixpariah";

  home.stateVersion = "23.11";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
