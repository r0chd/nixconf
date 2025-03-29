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
    ./programs
    ./security
    ./network
    ./services
    ../hosts/${hostname}/users/${username}/configuration.nix
    ../theme
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.email = lib.mkOption { type = lib.types.str; };

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services.udiskie.enable = system_type == "desktop";

    programs.home-manager.enable = true;
    home = {
      inherit username;
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "bak";
      packages = with pkgs; [
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
        #(writeShellScriptBin "deploy" ''
        #${pkgs.deploy-rs}/bin/deploy -d |& ${pkgs.nix-output-monitor}/bin/nom --json
        #'')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.05";
    };
  };
}
