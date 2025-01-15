{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.browser;
in
{
  config = lib.mkIf (cfg.enable && cfg.variant == "chromium") {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        { id = "ocaahdebbfolfmndjeplogmgcagdmblk"; }
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        { id = "ecjfaoeopefafjpdgnfcjnhinpbldjij"; }
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      ];
    };
  };
}
