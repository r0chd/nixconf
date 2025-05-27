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
            laptop.id = "RCRE2U4-2IJVC3Q-UQFV2CG-BRVTZV6-YHNCBPP-5RC4LHS-KNDGUCW-TBCRZQ7";
            laptop-lenovo.id = "Q2FHUUI-DZ6YABO-TJ2F45Y-VYXKAZT-X3UN5R4-CY6LP4K-VEBZYMD-XFKTEAZ";
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
        (writeShellScriptBin "shell" ''nix shell ''${NH_FLAKE}#homeConfigurations.${username}@${hostname}.pkgs.$1'')
        (writeShellScriptBin "run" ''nix run ''${NH_FLAKE}#homeConfigurations.${username}@${hostname}.pkgs.$1'')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.11";
    };
  };
}
