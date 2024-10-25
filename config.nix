{ lib }: {
  options = {
    username = lib.mkOption { type = lib.types.string; };
    cursor = {
      enable = lib.mkEnableOption "Enables cursor theme";
      program = lib.mkOption { type = lib.types.enum [ "bibata" ]; };
    };
    statusBar = {
      enable = lib.mkEnableOption "Enables status bar";
      program = lib.mkOption { type = lib.types.enum [ "waystatus" ]; };
    };
    terminal = {
      enable = lib.mkEnableOption "enables terminal emulator";
      program =
        lib.mkOption { type = lib.types.enum [ "kitty" "foot" "ghostty" ]; };
    };
    browser = {
      enable = lib.mkEnableOption "enables browser";
      program = lib.mkOption {
        type = lib.types.enum [ "firefox" "chromium" "qutebrowser" ];
      };
    };
    boot = {
      legacy = lib.mkEnableOption "enables legacy boot";
      program =
        lib.mkOption { type = lib.types.enum [ "grub" "systemd-boot" ]; };
    };
    notifications = {
      enable = lib.mkEnableOption "Enables notification daemon";
      program = lib.mkOption { type = lib.types.enum [ "mako" ]; };
    };
    lockscreen = {
      enable = lib.mkEnableOption "Enables lock screen";
      program = lib.mkOption { type = lib.types.enum [ "hyprlock" ]; };
    };
    launcher = {
      enable = lib.mkEnableOption "Enables app launcher";
      program = lib.mkOption { type = lib.types.enum [ "fuzzel" ]; };
    };
    colorscheme = lib.mkOption {
      type = lib.types.enum [ "none" "catppuccin" ];
      default = "none";
      description = "Colorscheme for entire system";
    };
    editor = lib.mkOption {
      type = lib.types.enum [ "nvim" ];
      default = "nvim";
      description = "current text editor";
    };
    shell = lib.mkOption {
      type = lib.types.enum [ "zsh" "fish" "bash" ];
      description = "current shell";
    };
    font = lib.mkOption {
      type = lib.types.string;
      default = "Arial";
      description = "system font";
    };
    wallpaper = {
      enable = lib.mkEnableOption "enables wallpaper";
      program = lib.mkOption {
        type = lib.types.string;
        default = "ruin";
      };
      path = lib.mkOption {
        type = lib.types.path {
          default = ./.;
          description = "Path to wallpaper";
        };
      };
    };
    seto.enable = lib.mkEnableOption "enables seto";
    power.enable = lib.mkEnableOption "enables power management";
    tmux.enable = lib.mkEnableOption "enables tmux";
    nh.enable = lib.mkEnableOption "enables neovim helper";
    zoxide.enable = lib.mkEnableOption "enables zoxide";
    man.enable = lib.mkEnableOption "enables man pages";
    lsd.enable = lib.mkEnableOption "enables lsd";
    bat.enable = lib.mkEnableOption "enables bat";
    direnv.enable = lib.mkEnableOption "enables direnv";
    nix-index.enable = lib.mkEnableOption "enables nix-index";
    wireless.enable = lib.mkEnableOption "enables wireless";
    bluetooth.enable = lib.mkEnableOption "enables bluetooth";
    audio.enable = lib.mkEnableOption "enables audio";
    virtualization.enable = lib.mkEnableOption "enables virtualization";
    zram.enable = lib.mkEnableOption "enables zram";
    ydotool.enable = lib.mkEnableOption "enables ydotool";
  };
}
