{
  pkgs,
  lib,
  username,
  inputs,
  config,
  hostName,
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
    ../hosts/${hostName}/users/${username}/configuration.nix
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
            laptop.id = "LEAMXII-NKCVKIN-E57LYGM-BH4LU2M-DYVNWIQ-VU4QGGN-UYMGRRN-D6Q44AI";
            laptop-lenovo.id = "WDQSKWW-TUA4E3I-PJOAPWK-LBXAWWC-7AJHLWN-ILXXBSQ-J72XNQE-RIAO7QV";
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
      persist.directories = [ ".local/state/syncthing" ];
      inherit username;
      packages = with pkgs; [
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
        (writeShellScriptBin "shell" ''nix shell ''${NH_FLAKE}#homeConfigurations.${username}@${hostName}.pkgs.$1'')
        (writeShellScriptBin "run" ''nix run ''${NH_FLAKE}#homeConfigurations.${username}@${hostName}.pkgs.$1'')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.11";
    };
  };
}
