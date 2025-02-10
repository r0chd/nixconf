{ inputs, ... }:
{
  imports = [
    inputs.moxalert.homeManagerModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      moxalert = inputs.moxalert.packages.${prev.system}.default;
    })
  ];

  services.moxalert = {
    enable = true;
    settings = {
      queue = "ordered";
      default_timeout = 5;
      ignore_timeout = false;
      output = "eDP-1";
      keymaps = {
        d = {
          action = "dismiss_notification";
        };
      };
      styles = {
        default = {
          font = {
            color = [
              230
              230
              230
              255
            ];
            size = 12;
            family = "JetBrains Mono NerdFont";
          };
          border = {
            size = 2;
            radius = {
              top_left = 5;
              top_right = 5;
              bottom_left = 5;
              bottom_right = 5;
            };
            color = [
              0.3
              0.5
              0.8
              1
            ];
          };
          padding = {
            top = 10;
            right = 0;
            bottom = 10;
            left = 10;
          };
          margin.top = 10;
          background_color = [
            0.1
            0.1
            0.1
            1
          ];
        };
        hover = {
          border = {
            color = [
              0.8
              0.6
              0.2
              1
            ];
          };
          background_color = [
            0.2
            0.4
            0.4
            1
          ];
        };
      };
    };
  };
}
