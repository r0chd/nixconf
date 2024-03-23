{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./configs/git.nix
    ./configs/qutebrowser.nix
    ./configs/tmux.nix
    ./configs/fish.nix
    ./configs/kitty.nix
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

  programs = {
    fish.enable = true;
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
