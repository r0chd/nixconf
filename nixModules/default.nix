{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config) shell nh bat zoxide docs grub username editor virtualization audio wireless hostname;
in {
  imports =
    [
      (import ./system/shell/default.nix {inherit shell pkgs;})
      (import ./environments/wayland/default.nix {inherit inputs config pkgs;})
      (import ./system/bootloader/default.nix {inherit grub;})
      (import ./security/default.nix {inherit username;})
      ./hardware/power/default.nix
      ./hardware/nvidia/default.nix
    ]
    ++ (
      if bat == true
      then [./tools/bat/default.nix]
      else []
    )
    ++ (
      if nh == true
      then [./tools/nh/default.nix]
      else []
    )
    ++ (
      if zoxide == true
      then [./tools/zoxide/default.nix]
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
      then [./virtualization/default.nix]
      else []
    )
    ++ (
      if audio == true
      then [./hardware/audio/default.nix]
      else []
    )
    ++ (
      if wireless == true
      then [(import ./network/wireless/default.nix {inherit pkgs hostname;})]
      else []
    );

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  users = {
    users."${config.username}" = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit shell;};
    users = {"${config.username}" = import ../home/home.nix {inherit shell;};};
  };

  specialisation = {
    Hyprland = {
      configuration = {
        imports = [
          (import ./environments/wayland/hyprland/default.nix {inherit shell inputs pkgs;})
        ];
        environment.etc."specialisation".text = "Hyprland";
      };
    };
    Sway = {
      configuration = {
        services.xserver.videoDrivers = ["nouveau"];
        imports = [
          (import ./environments/wayland/sway/default.nix {inherit shell inputs pkgs;})
        ];
        environment.etc."specialisation".text = "Sway";
      };
    };
  };
}
