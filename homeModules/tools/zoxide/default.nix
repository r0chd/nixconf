{ config, lib, username, ... }: {
  options.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf config.zoxide.enable {
    home-manager.users."${username}" = {
      impermanence.persist.directories =
        [ ".cache/zoxide" ".local/share/zoxide" ];
      programs.zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };
}
