{shell, ...}: {
  imports = [
    ./configs/git.nix
    ./configs/qutebrowser.nix
    ./configs/tmux.nix
    ./configs/kitty.nix
    ./configs/firefox.nix
    (
      if shell == "fish"
      then ./configs/fish.nix
      else if shell == "zsh"
      then ./configs/zsh.nix
      else ./configs/bash.nix
    )
  ];

  home = {
    username = "unixpariah";
    homeDirectory = "/home/unixpariah";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
