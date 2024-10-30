{ conf, pkgs, lib, std, inputs, }: {
  imports = [
    (import ./git { inherit conf std; })
    ./editor
    (import ./tmux { inherit pkgs conf lib; })
    (import ./nh { inherit conf lib pkgs std; })
    (import ./zoxide { inherit conf lib std; })
    ./lsd
    ./man
    (import ./bat { inherit conf lib std; })
    (import ./direnv { inherit conf lib std; })
    (import ./nix-index { inherit conf lib std; })
    ./ydotool
    (import ./seto { inherit conf pkgs inputs lib; })
  ];
}
