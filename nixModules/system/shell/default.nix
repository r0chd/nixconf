{
  shell,
  pkgs,
  ...
}: {
  users.defaultUserShell =
    if shell == "fish"
    then pkgs.fish
    else if shell == "zsh"
    then pkgs.zsh
    else pkgs.bash;

  programs = {
    fish.enable = shell == "fish";
    zsh.enable = shell == "zsh";
  };
}
