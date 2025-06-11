{
  lib,
  config,
  pkgs,
  systemUsers,
  ...
}:
let
  cfg = config.gaming.steam;
in
{
  options.gaming.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        (writeShellScriptBin "steamos-session-select" ''
          steam -shutdown
        '')
      ];

      persist.users.directories = [
        ".steam"
        "Games/Steam"
        ".local/share/Steam"
      ];
    };

    programs.steam = {
      enable = true;
      platformOptimizations.enable = true;
      protontricks.enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}
