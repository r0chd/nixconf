{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/git.nix
    ./configs/qutebrowser.nix
    ./configs/fish.nix
    ./configs/tmux.nix
  ];
  inputs.myflake.url = "path:/path/to/myflake";

  home.username = "unixpariah";
  home.homeDirectory = "/home/unixpariah";

  home.stateVersion = "23.11";

  home.packages = with packages; [
    myflake.packages.${system}
  ];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
