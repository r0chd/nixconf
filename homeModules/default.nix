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

    stylix.targets.hyprpaper.enable = false;

    services = {
      hyprpaper.enable = lib.mkForce false;
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
      stateVersion = "25.05";
    };
  };
}
