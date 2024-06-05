{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config) username browser term shell;
in {
  imports = [
    (import ./environments/wayland/default.nix {inherit inputs pkgs;})
    (import ./security/default.nix {inherit inputs username;})
    (import ./gui/default.nix {inherit inputs username pkgs browser;})
    (import ./tools/default.nix {inherit config inputs pkgs;})
    (import ./system/default.nix {inherit pkgs config;})
    (import ./hardware/default.nix {inherit config;})
    (import ./network/default.nix {inherit config pkgs inputs;})
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  users.users."${config.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  home-manager.users."${username}" = {
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
  };

  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  specialisation = {
    Hyprland.configuration = {
      imports = [
        (import ./environments/wayland/hyprland/default.nix {inherit inputs pkgs username term shell;})
      ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = {
      services.xserver.videoDrivers = ["nouveau"];
      imports = [
        (import ./environments/wayland/sway/default.nix {inherit inputs pkgs username term shell;})
      ];
      environment.etc."specialisation".text = "Sway";
    };
  };
}
