{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config) shell nh bat zoxide docs grub username;
in {
  imports =
    [
      (import ./system/shell/default.nix {inherit shell pkgs;})
      (import ./environments/wayland/default.nix {inherit inputs config pkgs;})
      (import ./system/bootloader/default.nix {inherit grub;})
      (import ./security/default.nix {inherit username;})
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
    );

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
