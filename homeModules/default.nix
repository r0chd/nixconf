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

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services = {
      syncthing = {
        enable = true;
        settings = {
          devices = {
            laptop.id = "F265KCD-YJPGOI2-SZJT5TH-FNDPNGU-S7CZGD6-75VIYU4-KN4OPOP-TVGCCQM";
            laptop_huawei.id = "";
            laptop-lenovo.id = "C5GUBSH-TR5VRA4-F33RW3V-3GOA7KC-R2CKVNS-2BT7EJW-44CBERS-OELDGAJ";
            laptop-thinkpad.id = "4G25JBC-D5FCDQR-TAVZASY-SS5Y2UV-JHCGHIJ-FIE4AXO-WJOQP6C-MKDKKAV";
            rpi.id = "GHWM5H6-XNTMGWE-BPB3LVW-ODDSP4M-GKVP5FX-AWC23Q2-H7F6WZB-KVY5FQ5";
          };
          folders = {
            "/var/lib/nixconf" = {
              path = "/var/lib/nixconf";
              devices = [
                "laptop"
                "rpi"
                "laptop-lenovo"
                "laptop-thinkpad"
              ];
            };
          };
        };
      };
      udiskie.enable = lib.mkDefault system_type == "desktop";
      sysnotifier.enable = lib.mkDefault system_type == "desktop";
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
