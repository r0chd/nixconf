{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/git.nix
    ./configs/qutebrowser.nix
    ./configs/tmux.nix
  ];

  home = {
    username = "unixpariah";
    homeDirectory = "/home/unixpariah";
    stateVersion = "23.11";
    packages = [];
    file = {};
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
