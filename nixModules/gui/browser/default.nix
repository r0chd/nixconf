{ config, inputs, pkgs, lib, std, username, ... }: {
  options.browser = {
    enable = lib.mkEnableOption "Enable browser";
    program = lib.mkOption {
      type = lib.types.enum [ "ladybird" "firefox" "chromium" "qutebrowser" ];
    };
  };

  imports = [
    (import ./firefox {
      inherit inputs pkgs lib std username;
      conf = config;
    })
    (import ./qutebrowser {
      inherit lib std username;
      conf = config;
    })
    (import ./chromium {
      inherit lib pkgs username;
      conf = config;
    })
    (import ./ladybird {
      inherit lib;
      conf = config;
    })
  ];
}
