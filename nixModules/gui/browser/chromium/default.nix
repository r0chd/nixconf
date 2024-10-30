{ lib, conf, pkgs, username }: {
  config =
    lib.mkIf (conf.browser.enable && conf.browser.program == "ladybird") {
      home-manager.users."${username}".programs.chromium = {
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
