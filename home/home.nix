{username, ...}: {
  imports = [
    ./configs/tmux.nix
    ./configs/kitty.nix
    (import ./configs/git.nix {inherit username;})
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
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
