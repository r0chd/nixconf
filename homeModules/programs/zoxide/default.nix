{ config, lib, ... }:
let
  cfg = config.programs.zoxide;
in
{
  config = lib.mkIf cfg.enable {
    impermanence.persist.directories = [
      ".local/share/zoxide"
    ];
    programs.zoxide = {
      options = [ "--cmd cd" ];
    };
  };
}
