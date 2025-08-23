{
  config,
  lib,
  profile,
  platform,
  pkgs,
  ...
}:
let
  cfg = config.environment.wallpaper;
in
{
  options.environment.wallpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = profile == "desktop";
    };
  };

  config = {
    services = {
      hyprpaper.enable = lib.mkForce false;
      moxpaper = {
        inherit (cfg) enable;
        package = lib.mkIf (platform == "non-nixos") (config.lib.nixGL.wrap pkgs.moxpaper);

        settings = {
          power_preference = "high_performance";
          enabled_transition_types = [
            "spiral"
            "bounce"
            "blur_fade"
            "blur_spiral"
          ];
          default_transition_type = "random";
          bezier.overshot = [
            0.05
            0.9
            0.1
            1.05
          ];
        };

        transitions = {
          spiral = ''
            function(params)
              local progress = params.progress
              local time_factor = params.time_factor
              local rand = params.rand
              local angle = time_factor * math.pi * 4.0
              local distance = (1.0 - progress) * 0.5
              local center_x = 0.5 + distance * math.cos(angle)
              local center_y = 0.5 + distance * math.sin(angle)
              local size = progress
              return {
                transforms = {
                  translate = { center_x - size * 0.5, center_y - size * 0.5 },
                  scale_x = size,
                  scale_y = size
                },
                radius = 0.5 * (1.0 - time_factor),
                rotation = progress * 360,
              }
            end
          '';

          blur_spiral = ''
            function(params)
              local progress = params.progress
              local time_factor = params.time_factor
              local rand = params.rand
              local angle = time_factor * math.pi * 4.0
              local distance = (1.0 - progress) * 0.5
              local center_x = 0.5 + distance * math.cos(angle)
              local center_y = 0.5 + distance * math.sin(angle)
              local size = progress
              return {
                transforms = {
                  translate = { center_x - size * 0.5, center_y - size * 0.5 },
                  scale_x = size,
                  scale_y = size
                },
                radius = 0.5 * (1.0 - time_factor),
                rotation = progress * 360,
                filters = {
                  blur = progress * 15,
                },
              }
            end
          '';

          slide_left = ''
            function(params)
              local progress = params.progress

              return {
                transforms = {
                  translate = { 1 - progress, 0 }, -- Assuming y remains 0 for horizontal slide
                  scale_x = 1, -- Assuming width remains 1
                  scale_y = 1  -- Assuming height remains 1
                },
              }
            end
          '';

          slide_right = ''
            function(params)
              local progress = params.progress

              return {
                transforms = {
                  translate = { progress - 1, 0 }, -- Assuming y remains 0 for horizontal slide
                  scale_x = 1, -- Assuming width remains 1
                  scale_y = 1  -- Assuming height remains 1
                },
              }
            end
          '';

          slide_top = ''
            function(params)
              local progress = params.progress

              return {
                transforms = {
                  translate = { 0, 1 - progress }, -- Assuming x remains 0 for vertical slide
                  scale_x = 1, -- Assuming width remains 1
                  scale_y = 1  -- Assuming height remains 1
                },
              }
            end
          '';

          slide_bottom = ''
            function(params)
              local progress = params.progress

              return {
                transforms = {
                  translate = { 0, progress - 1 }, -- Assuming x remains 0 for vertical slide
                  scale_x = 1, -- Assuming width remains 1
                  scale_y = 1  -- Assuming height remains 1
                },
              }
            end
          '';

          bounce = ''
            function(params)
              local progress = params.progress
              local time_factor = params.time_factor
              local bounce_factor = math.sin(progress * math.pi * 4) * (1.0 - progress) * 0.2
              local effective_progress = progress + bounce_factor
              effective_progress = math.max(0.0, math.min(1.0, effective_progress))
              local center = 0.5
              local half_extent = 0.5 * effective_progress
              return {
                transforms = {
                  translate = { center - half_extent, center - half_extent },
                  scale_x = effective_progress,
                  scale_y = effective_progress
                },
                radius = (1.0 - effective_progress) * 0.5,
              }
            end
          '';

          blur_fade = ''
            function(params)
              local progress = params.progress
              local time_factor = params.time_factor
              
              local opacity = progress
              
              return {
                filters = {          
                  blur = 20,
                  opacity = opacity,
                },
              }
            end
          '';

          full_filter_showcase = ''
            function(params)
              local progress = math.max(0.0, math.min(1.0, params.progress or 0))
              local time_factor = params.time_factor or 0
              local inv_progress = 1.0 - progress
              local pulse = 0.5 + 0.5 * math.sin(time_factor * math.pi * 2)

              -- Scale from 0 to 1.0 so it looks like it's getting closer and closer
              local scale = progress
              
              -- Center the image: position = 0.5 - (scale * 0.5)
              local center_offset = 0.5 - (scale * 0.5)

              return {
                transforms = {
                  translate = { center_offset, center_offset },
                  scale_x = scale,
                  scale_y = scale,
                },
                radius = 0.2 * inv_progress,
                rotation = inv_progress * 360 * math.pi * 2,
                filters = {
                  opacity = 0.2 + 0.8 * progress,
                  brightness = 0.5 * inv_progress,
                  contrast = 0.5 + 0.5 * progress,
                  saturation = 0.5 + 0.5 * progress,
                  hue_rotate = 180 * inv_progress,
                  sepia = 0.5 * inv_progress,
                  invert = 0.5 * inv_progress,
                  grayscale = 0.5 * inv_progress,
                  blur = 15 * inv_progress,
                  blur_color = {
                    0.3 * inv_progress,
                    0.1 * inv_progress,
                    0.2 * inv_progress,
                    1.0
                  },
                  skew = {
                    30 * inv_progress,
                    15 * math.sin(time_factor * math.pi)
                  },
                },
              }
            end
          '';

          rotate = ''
            function(params)
              local progress = params.progress
              local size = 0.6
              return {
                transforms = {
                  translate = { 0.5 - size * 0.5, 0.5 - size * 0.5 },
                  scale_x = size,
                  scale_y = size,
                },
                rotation = progress * 360,
              }
            end
          '';
        };
      };
    };

    nix.settings = lib.mkIf cfg.enable {
      substituters = [ "https://moxpaper.cachix.org" ];
      trusted-substituters = [ "https://moxpaper.cachix.org" ];
      trusted-public-keys = [ "moxpaper.cachix.org-1:zaa2mQr8uPaaqPIUJGza+O3uimu0/KtJmH471q01WwU=" ];
    };
  };
}
