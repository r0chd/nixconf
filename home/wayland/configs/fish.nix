{pkgs, ...}: {
  programs.fish = {
    shellAliases = {
      obs = "env -u WAYLAND_DISPLAY obs";
    };
  };
}
