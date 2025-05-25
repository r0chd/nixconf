{
  pkgs,
  lib,
  username,
  inputs,
  config,
  hostname,
  system_type,
  ...
}:
{
  imports = [
    ./nix
    ./gaming
    ./environment
    ./workspace
    ./programs
    ./security
    ./networking
    ./services
    ../hosts/${hostname}/users/${username}/configuration.nix
    ../theme
  ];

  options.email = lib.mkOption { type = lib.types.str; };

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services = {
      syncthing = {
        enable = true;
        settings = {
          devices = {
            laptop.id = "6MT4MX2-ON22DDI-KKF46LZ-XALOSVK-3ZFV55O-OACNX2G-UCNI5JI-EOMBKAR";
            laptop-lenovo.id = "BNERVG4-7SCAOKG-FQBVLLE-GRBOSXA-DHUI2CL-U3LI3FE-FDJQHKP-362SJQD";
            rpi.id = "GHWM5H6-XNTMGWE-BPB3LVW-ODDSP4M-GKVP5FX-AWC23Q2-H7F6WZB-KVY5FQ5";
          };
          folders = {
            "/var/lib/nixconf" = {
              path = "/var/lib/nixconf";
              devices = [
                "laptop"
                "rpi"
                "laptop-lenovo"
              ];
            };
          };
        };
      };
      udiskie.enable = system_type == "desktop";
      sysnotifier.enable = system_type == "desktop";
    };

    programs = {
      home-manager.enable = true;
    };
    home = {
      inherit username;
      packages = with pkgs; [
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
        (writeShellScriptBin "shell" ''nix shell /var/lib/nixconf#homeConfigurations.${username}@${hostname}.pkgs.$1'')
        (writeShellScriptBin "run" ''nix run /var/lib/nixconf#homeConfigurations.${username}@${hostname}.pkgs.$1'')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.11";
    };
  };
}
