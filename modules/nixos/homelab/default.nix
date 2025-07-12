{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.homelab;
  configFile = inputs.nix-cue.lib.${pkgs.system}.eval {
    inherit pkgs;
    inputFiles = [ ./pre-commit.cue ];
    outputFile = ".pre-commit-config.yaml";
    data = {
      repos = [
        {
          repo = "https://github.com/test/repo";
          rev = "1.0";
          hooks = [ { id = "my-hook"; } ];
        }
      ];
    };
  };
in
{
  options.homelab = {
    enable = lib.mkEnableOption "homelab";
  };

  #config = lib.mkIf cfg.enable { };

  config = {
    systemd.services.cue-service = {
      description = "Apply cue";
      wantedBy = [ "system-manager.target" ];
      before = [ "system-manager.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        unlink .pre-commit-config.yaml
        ln -s ${configFile} .pre-commit-config.yaml
      '';
      restartIfChanged = true;
    };
  };
}
