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
    ./configs/waybar.nix
    ./configs/hyprland.nix
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

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
