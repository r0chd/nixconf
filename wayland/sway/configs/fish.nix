{pkgs, ...}: {
  programs.fish = {
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
          sway
      end
    '';
  };
}
