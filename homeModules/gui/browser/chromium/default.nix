{ lib, config, pkgs, ... }: {
  config =
    lib.mkIf (config.browser.enable && config.browser.program == "chromium") {
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
