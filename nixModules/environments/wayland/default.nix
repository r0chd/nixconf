{
  inputs,
  pkgs,
  ...
}: let
  waystatus = import (pkgs.fetchgit {
    url = "https://github.com/unixpariah/waystatus.git";
    sha256 = "0x4y6gisbbzf86j8ab00h271iyn5s8c3ql16458i8pablxfbllpl";
    fetchSubmodules = true;
  }) {pkgs = pkgs;};
  ruin = import (pkgs.fetchgit {
    url = "https://github.com/unixpariah/ruin.git";
    sha256 = "1l6wj88z48jppvg182y7nphh8yzknb1718xxcsl1n5dm068svygd";
  }) {pkgs = pkgs;};
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  environment.shellAliases = {
    obs = "env -u WAYLAND_DISPLAY obs";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland
    obs-studio
    nix-prefetch-git
    waystatus
    ruin
  ];
}
