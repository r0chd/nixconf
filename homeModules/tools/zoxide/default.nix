{ config, lib, ... }:
{
  options.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf config.zoxide.enable {
    impermanence.persist.directories = [
      ".cache/zoxide"
      ".local/share/zoxide"
    ];
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
