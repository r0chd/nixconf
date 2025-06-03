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
    ../common/home
  ];

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services = {
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
