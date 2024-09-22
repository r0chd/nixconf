{
  hostname,
  arch,
  disableAll,
}: let
  commonConfig = {
    arch = arch;
    hostname = hostname;
    colorscheme = "catppuccin";
    font = "JetBrainsMono Nerd Font";
    boot.loader = "grub";
    boot.legacy = false;
    power = false;
  };
  defaultConfig = {
    editor = "nvim";
    shell = "zsh";
    tmux = true;
    seto = true;
    nh = true;
    zoxide = true;
    man = true;
    lsd = true;
    bat = true;
    direnv = true;
    nix-index = true;
    wireless = true;
    bluetooth = true;
    audio = true;
    virtualization = true;
    zram = true;
    ydotool = true;
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
    wireless = false;
    bluetooth = false;
    audio = false;
    virtualization = false;
    zram = false;
    ydotool = false;
  };
in
  if disableAll
  then commonConfig // minimalConfig
  else commonConfig // defaultConfig
