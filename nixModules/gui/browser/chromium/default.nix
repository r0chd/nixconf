{
  username,
  pkgs,
}: {
  home-manager.users."${username}".programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      {id = "ocaahdebbfolfmndjeplogmgcagdmblk";}
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "ecjfaoeopefafjpdgnfcjnhinpbldjij";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
    ];
  };
}
