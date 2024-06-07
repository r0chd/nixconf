{pkgs, ...}: let
  waystatus = import (pkgs.fetchgit {
    url = "https://github.com/unixpariah/waystatus.git";
    rev = "8e9e1ac3bed2237b19ec06ed5e45d766f310afd4";
    sha256 = "0c1c1qiv0c7lb25vgbd3d8947zc38d06n8lf5hvrmx3zzakc62a0";
    fetchSubmodules = true;
  }) {pkgs = pkgs;};
  ruin = import (pkgs.fetchgit {
    url = "https://github.com/unixpariah/ruin.git";
    sha256 = "1l6wj88z48jppvg182y7nphh8yzknb1718xxcsl1n5dm068svygd";
  }) {pkgs = pkgs;};
  # seto = import (pkgs.fetchgit {
  #   url = "https://github.com/unixpariah/seto.git";
  #   sha256 = "1gnl9wh01xd09v9j9hsbz2mbcq21yqiin11d6bl8vddc9x4czb55";
  # }) {pkgs = pkgs;};
in {
  environment.shellAliases = {
    obs = "env -u WAYLAND_DISPLAY obs";
  };

  environment.systemPackages = with pkgs; [
    waystatus
    wl-clipboard
    wayland
    obs-studio
    nix-prefetch-git
    ruin
    #   seto
  ];
}
