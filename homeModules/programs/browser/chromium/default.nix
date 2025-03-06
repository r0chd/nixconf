{
  pkgs,
  ...
}:
{
  config = {
    programs.chromium = {
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
