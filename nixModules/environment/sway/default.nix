{
  lib,
  system_type,
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.sway = {
    enable = lib.mkDefault (system_type == "desktop");
    extraOptions = [ "--unsupported-gpu" ];
    extraPackages = [ ];
  };

  xdg.portal = lib.mkIf config.programs.sway.enable {
    enable = true;
    wlr = {
      enable = lib.mkForce true;
      settings = {
        screencast = {
          chooser_cmd = "${inputs.seto.packages.${pkgs.system}.default}/bin/seto -f %o";
          chooser_type = "simple";
        };
      };
    };
  };
}
