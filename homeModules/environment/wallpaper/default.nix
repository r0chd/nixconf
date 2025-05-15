{
  config,
  lib,
  system_type,
  inputs,
  ...
}:
let
  cfg = config.environment.wallpaper;
in
{
  imports = [
    inputs.moxpaper.homeManagerModules.default
    inputs.moxpaper.homeManagerModules.stylix
  ];

  options.environment.wallpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = system_type == "desktop";
    };
  };

  config.services.moxpaper = {
    inherit (cfg) enable;

    settings = {
      enabled_transition_types = [
        "spiral"
        "spiral_funky"
        "bounce"
      ];
      default_transition_type = "random";
      bezier.overshot = [
        0.05
        0.9
        0.1
        1.05
      ];
    };

    extraConfig =
      # lua
      ''
        transitions = {}

        transitions.spiral_funky = function(params)
          local progress = params.progress
          local time_factor = params.time_factor
          local rand = params.rand

          local angle = time_factor * math.pi * 32.0
          local distance = (1.0 - progress) * 0.5
          local center_x = 0.5 + distance * math.cos(angle)
          local center_y = 0.5 + distance * math.sin(angle)

          return {
            extents = {
              x = center_x - size * 0.5,
              y = center_y - size * 0.5,
              width = size,
              height = size
            },
            radius = 0.5 * (1.0 - time_factor),
            rotation = progress * 3,
          }
        end

        transitions.spiral = function(params)
          local progress = params.progress
          local time_factor = params.time_factor
          local rand = params.rand
          local angle = time_factor * math.pi * 4.0
          local distance = (1.0 - progress) * 0.5
          local center_x = 0.5 + distance * math.cos(angle)
          local center_y = 0.5 + distance * math.sin(angle)
          local size = progress
          return {
            extents = {
              x = center_x - size * 0.5,
              y = center_y - size * 0.5,
              width = size,
              height = size
            },
            radius = 0.5 * (1.0 - time_factor),
            rotation = progress,
          }
        end

        transitions.slide_left = function(params)
          local progress = params.progress

          return {
            extents = {
              x = 1 - progress,
            },
          }
        end

        transitions.slide_right = function(params)
          local progress = params.progress

          return {
            extents = {
              x = progress - 1,
            },
          }
        end

        transitions.slide_top = function(params)
          local progress = params.progress

          return {
            extents = {
              y = 1 - progress,
            },
          }
        end

        transitions.slide_bottom = function(params)
          local progress = params.progress

          return {
            extents = {
              y = progress - 1,
            },
          }
        end

        transitions.bounce = function(params)
          local progress = params.progress
          local time_factor = params.time_factor
          local bounce_factor = math.sin(progress * math.pi * 4) * (1.0 - progress) * 0.2
          local effective_progress = progress + bounce_factor
          effective_progress = math.max(0.0, math.min(1.0, effective_progress))
          local center = 0.5
          local half_extent = 0.5 * effective_progress
          return {
            extents = {
              x = center - half_extent,
              y = center - half_extent,
              width = effective_progress,
              height = effective_progress
            },
            radius = (1.0 - effective_progress) * 0.5,
          }
        end
      '';
  };

}
