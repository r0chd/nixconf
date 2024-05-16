{
  pkgs,
  shell,
  username,
  ...
}: {
  imports = [
    (
      if shell == "fish"
      then (import ./fish/default.nix {inherit username pkgs;})
      else if shell == "zsh"
      then (import ./zsh/default.nix {inherit username pkgs;})
      else
        (
          import ./bash/default.nix {inherit username pkgs;}
        )
    )
  ];
}
