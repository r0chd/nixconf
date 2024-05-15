{shell, ...}: {
  imports = [
    ./configs/sway.nix
    (
      if shell == "fish"
      then ./configs/fish.nix
      else if shell == "zsh"
      then ./configs/zsh.nix
      else ./configs/bash.nix
    )
  ];
}
