{
  pkgs,
  ...
}:
{
  programs = {
    man.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    lsd.enable = true;
    direnv.enable = true;
    nix-index.enable = true;
    tmux.enable = true;
    btop.enable = true;
  };

  services.yubikey-touch-detector = {
    enable = true;
  };
  editor = "nvim";
  email = "oskar.rochowiak@tutanota.com";
  sops = {
    secrets = {
      aoc-session = { };
      nixos-access-token-github = { };
    };
    # templates."nix.conf" = {
    #   path = "/home/unixpariah/.config/nix/nix.conf";
    #   content = ''
    #     access-tokens = github.com=${config.sops.placeholder.nixos-access-token-github}
    #   '';
    # };
  };

  stylix = {
    enable = true;
    targets.fish.enable = false;
    cursor = {
      name = "Banana";
      package = pkgs.banana-cursor;
      size = 36;
    };
    fonts = {
      sizes = {
        terminal = 9;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
    opacity = {
      terminal = 0.0;
    };
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
      sha256 = "7e6285630da06006058cebf896bf089173ed65f135fbcf32290e2f8c471ac75b";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
  };

  home.packages = with pkgs; [
    lazygit
    unzip
  ];

  impermanence = {
    enable = true;
    persist = {
      directories = [
        "workspace"
      ];
    };
  };

}
