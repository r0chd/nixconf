{
  hostname,
  disableAll,
}: let
  commonConfig = {
    hostname = hostname;
    colorscheme = "catppuccin";
    font = "JetBrainsMono Nerd Font";
    boot.loader = "grub";
    boot.legacy = false;
    power = false;
  };
  defaultConfig = {
    terminal = "foot";
    statusBar = "waystatus";
    editor = "nvim";
    shell = "zsh";
    browser = "firefox";
    notifications = "mako";
    tmux = true;
    seto = true;
    nh = true;
    zoxide = true;
    man = true;
    lsd = true;
    bat = true;
    direnv = true;
    nix-index = true;
    ruin = true;
    wireless = true;
    bluetooth = true;
    audio = true;
    virtualization = true;
    zram = true;
  };
  minimalConfig = {
    tmux = false;
    seto = false;
    nh = false;
    zoxide = false;
    man = false;
    lsd = false;
    bat = false;
    direnv = false;
    nix-index = false;
    ruin = false;
    wireless = false;
    bluetooth = false;
    audio = false;
    virtualization = false;
    zram = false;
  };
in
  if disableAll
  then commonConfig // minimalConfig
  else commonConfig // defaultConfig
