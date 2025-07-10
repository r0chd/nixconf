{ pkgs, config, ... }:
{
  sops.secrets = {
    "yubico/u2f_keys".path = "/home/unixpariah/.config/Yubico/u2f_keys";
    github-api = { };
    "ssh_keys/id_yubikey".path = "/home/unixpariah/.ssh/id_yubikey";
    atuin_key = { };
  };

  programs = {
    keepassxc.enable = true;
    atuin = {
      enable = false;
      settings.key_path = config.sops.secrets.atuin_key.path;
    };
    git = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    editor = "hx";
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    nixcord.vesktop.enable = true;
    zen-browser.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    seto.enable = true;
    bottom.enable = true;
  };

  environment = {
    terminal.program = "ghostty";
  };

  home.persist.directories = [
    "workspace"
    ".yubico"
  ];

  services = {
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
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
