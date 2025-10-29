{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.programs.atuin;
in
{
  options.programs.atuin = {
    distributed = {
      enable = lib.mkEnableOption "atuin-distributed";
      address = lib.mkOption {
        type = types.str;
      };
    };
  };

  config.programs.atuin = {
    daemon.enable = true;
    settings = lib.mkIf cfg.distributed.enable {
      sync.records = true;
      sync_frequency = "1";
      daemon.sync_frequency = "1";
      auto_sync = true;
      sync_address = cfg.distributed.address;
    };
  };
}
