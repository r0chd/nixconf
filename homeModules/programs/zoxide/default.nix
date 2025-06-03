{ config, lib, ... }:
let
  cfg = config.programs.zoxide;
in
{
  config = lib.mkIf cfg.enable {
    home.persist.directories = [
      ".local/share/zoxide"
    ];

    programs.zoxide = {
      options = [ "--cmd cd" ];
    };
  };
}
