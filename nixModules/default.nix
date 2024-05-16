{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config) shell nh zoxide docs grub username editor virtualization audio wireless hostname power browser;
in {
  imports =
    [
      (import ./system/shell/default.nix {inherit inputs shell pkgs username;})
      (import ./environments/wayland/default.nix {inherit inputs pkgs;})
      (import ./system/bootloader/default.nix {inherit inputs grub;})
      (import ./security/default.nix {inherit inputs username;})
      (import ./gui/default.nix {inherit inputs username pkgs browser;})
      ./hardware/nvidia/default.nix
    ]
    ++ (
      if nh == true
      then [(import ./tools/nh/default.nix {inherit username pkgs;})]
      else []
    )
    ++ (
      if zoxide == true
      then [(import ./tools/zoxide/default.nix {inherit username shell pkgs inputs;})]
      else []
    )
    ++ (
      if docs == true
      then [./docs/default.nix]
      else []
    )
    ++ (
      if editor == "nvim"
      then [./tools/nvim/default.nix]
      else []
    )
    ++ (
      if virtualization == true
      then [(import ./virtualization/default.nix {inherit username;})]
      else []
    )
    ++ (
      if audio == true
      then [./hardware/audio/default.nix]
      else []
    )
    ++ (
      if wireless == true
      then [(import ./network/wireless/default.nix {inherit pkgs inputs hostname;})]
      else []
    )
    ++ (
      if power == true
      then [./hardware/power/default.nix]
      else []
    );

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  users.users."${config.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs shell username;};
    users = {"${config.username}" = import ../home/home.nix {inherit inputs shell username pkgs;};};
  };

  specialisation = {
    Hyprland = {
      configuration = {
        imports = [
          (import ./environments/wayland/hyprland/default.nix {inherit shell inputs pkgs username;})
        ];
        environment.etc."specialisation".text = "Hyprland";
      };
    };
    Sway = {
      configuration = {
        services.xserver.videoDrivers = ["nouveau"];
        imports = [
          (import ./environments/wayland/sway/default.nix {inherit inputs shell pkgs username;})
        ];
        environment.etc."specialisation".text = "Sway";
      };
    };
  };
}
