{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "obsidian" ];

  programs = {
    editor = "hx";
    git.email = "os1@qed.ai";
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
  };

  environment = {
    terminal.program = "foot";
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues { inherit (pkgs) obsidian; };
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
    cursor.size = 36;
    opacity.terminal = 0.8;
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
