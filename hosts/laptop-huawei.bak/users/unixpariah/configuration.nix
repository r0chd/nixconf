{ pkgs, ... }:
{
  programs = {
    git.email = "100892812+unixpariah@users.noreply.github.com";
    editor = "hx";
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    zen.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    seto.enable = true;
    btop.enable = true;
    keepassxc.enable = true;
  };

  environment = {
    terminal.program = "ghostty";
  };

  services = {
    impermanence.enable = false;
  };

  wayland.windowManager = {
    hyprland.enable = false;
    sway.enable = false;
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
    cursor.size = 36;
    opacity.terminal = 0.4;
    fonts = {
      sizes.terminal = 9;
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
