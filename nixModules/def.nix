{ config, inputs, pkgs, lib, username, arch, std, ... }: {
  specialisation = {
    Hyprland.configuration = let
      window-manager = {
        enable = true;
        name = "Hyprland";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "Hyprland";
      imports = [
        (import ./default.nix {
          inherit config inputs pkgs lib username window-manager;
        })
        (import ./environments {
          inherit config inputs pkgs lib username window-manager;
        })
      ];
    };
    sway.configuration = let
      window-manager = {
        enable = true;
        name = "sway";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "sway";
      imports = [
        (import ./default.nix {
          inherit config inputs pkgs lib username window-manager;
        })
        (import ./environments {
          inherit config inputs pkgs lib arch std username window-manager;
        })
      ];
    };
    niri.configuration = let
      window-manager = {
        enable = true;
        name = "niri";
        backend = "Wayland";
      };
    in {
      environment.etc."specialisation".text = "niri";
      imports = [
        (import ./default.nix {
          inherit config inputs pkgs lib username window-manager;
        })
        (import ./environments {
          inherit config inputs pkgs lib username window-manager;
        })
      ];
    };
  };
}
