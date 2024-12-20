{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config) colorscheme;
  cfg = config.environment.window-manager;
in
{
  config = lib.mkIf (cfg.enable && cfg.name == "gamescope") {
    home = {
      # file.".steam/steam/steam_dev.cfg".text = ''
      #   unShaderBackgroundProcessingThreads 8
      #   @nClientDownloadEnableHTTP2PlatformLinux 0
      # '';
      sessionVariables = {
        MANGOHUD = "1";
      };
      packages = with pkgs; [
        (lutris.override { extraPkgs = pkgs: [ ]; })
        prismlauncher
        heroic
        protonup
      ];
    };

    impermanence.persist.directories = [
      ".config/heroic"
      "Games/Heroic"
      ".local/share/PrismLauncher"
      ".local/share/lutris"
      "Games/Lutris"
      {
        directory = ".steam";
        method = "symlink";
      }
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      "Games/Steam"
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        input = {
          monitor = lib.mapAttrsToList (
            name: value:
            "${name}, ${toString value.dimensions.width}x${toString value.dimensions.height}@${toString value.refresh}, ${toString value.position.x}x${toString value.position.y}, ${toString value.scale}"
          ) config.environment.outputs;

          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = "1";

          touchpad = {
            disable_while_typing = "false";
            natural_scroll = "no";
          };

          sensitivity = "0";
          accel_profile = "flat";
        };

        general =
          let
            inherit (colorscheme) accent1 inactive;
          in
          {
            "col.active_border" = "rgb(${accent1})";
            "col.inactive_border" = "rgb(${inactive})";

            border_size = 1;
            gaps_out = 0;
            gaps_in = 0;
          };

        decoration.blur.enabled = false;

        debug.disable_logs = false;

        animations.enabled = false;

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        gestures = {
          workspace_swipe = "off";
        };

        misc = {
          force_default_wallpaper = "0";
          disable_hyprland_logo = "true";
          vfr = "true";
        };

        "$mainMod" = "ALT"; # Mod key

        exec-once = [ ];

        bind = [
          # Brightness
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

          # Manage workspace
          "$mainMod SHIFT, C, killactive,"
          "$mainMod, F, togglefloating,"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "ALT, less, pass, ^discord$"

          # Move to next workspace with mainMod + [M/N]
          "$mainMod, N, workspace, e-1"
          "$mainMod, M, workspace, e+1"

          # Move active window to next workspace with mainMod + [M/N]
          "$mainMod SHIFT, N, movetoworkspace, -1"
          "$mainMod SHIFT, M, movetoworkspace, +1"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ] ++ (lib.optional (config.terminal.enable) "$mainMod SHIFT, RETURN, exec, fuzzel");
      };
    };
  };
}
