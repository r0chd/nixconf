{
  username,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./configs/qutebrowser.nix
    ./configs/tmux.nix
    ./configs/kitty.nix
    (import ./configs/git.nix {inherit username;})
    (import ./configs/firefox.nix {inherit username pkgs inputs;})
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
    zoxide.enableBashIntegration = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
