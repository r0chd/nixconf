{ conf, pkgs, lib, std, inputs, }: {
  imports = [
    (import ./git { inherit conf std; })
    (import ./editor { inherit pkgs inputs conf lib std; })
    (import ./tmux { inherit pkgs conf lib; })
    (import ./nh { inherit conf lib pkgs std; })
    (import ./zoxide { inherit conf lib std; })
    (import ./lsd { inherit conf lib; })
    (import ./man { inherit conf lib pkgs; })
    (import ./bat { inherit conf lib std; })
    (import ./direnv { inherit conf lib std; })
    (import ./nix-index { inherit conf lib std; })
    (import ./ydotool { inherit conf lib; })
    (import ./seto { inherit conf pkgs inputs lib; })
  ];
}
