{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gaming.gamescope;
in
{
  options.gaming.gamescope.enable = lib.mkEnableOption "gamescope";

  config = lib.mkIf cfg.enable {
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      (pkgs.writeShellScriptBin "gamescope-session-uwsm" ''
        #!/usr/bin/env bash
        set -xeuo pipefail

        mangoConfig=(
            cpu_temp
            gpu_temp
            ram
            vram
        )
        mangoVars=(
            MANGOHUD=1
            MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
        )

        gamescopeArgs=(
            --adaptive-sync 
            --hdr-enabled    
            --mangoapp        
            --rt               
            --steam             
            --expose-wayland     
            --force-grab-cursor   
        )

        steamArgs=(
            -steamdeck
            -steamos3
            -pipewire-dmabuf      
            -tenfoot               
        )

        export "''${mangoVars[@]}"

        gamescope "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}" &
        GAMESCOPE_PID=$!

        FINALIZED="I'm here" WAYLAND_DISPLAY=gamescope-0 uwsm finalize

        wait $GAMESCOPE_PID
      '')
    ];
  };
}
