{ conf, pkgs, lib, std, inputs, }: {
  imports = [
    (import ./git { inherit conf std; })
    (import ./nvim { inherit pkgs inputs conf lib; })
    (import ./tmux { inherit pkgs conf lib; })
    (import ./nh { inherit conf lib pkgs std; })
    (import ./zoxide { inherit conf lib; })
    (import ./lsd { inherit conf lib; })
    (import ./man { inherit conf lib pkgs; })
    (import ./bat { inherit conf lib; })
    (import ./direnv { inherit conf lib; })
    (import ./nix-index { inherit conf lib; })
    (import ./ydotool { inherit conf lib; })
    (import ./seto { inherit conf pkgs inputs lib; })
  ];
}
