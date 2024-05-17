{
  term,
  inputs,
  username,
  shell,
  ...
}: {
  imports = [
    (import ./configs/home.nix {inherit inputs username term;})
    (
      if shell == "fish"
      then ./configs/fish.nix
      else if shell == "zsh"
      then ./configs/zsh.nix
      else ./configs/bash.nix
    )
  ];

  security.polkit.enable = true;
}
