{
  conf,
  pkgs,
  lib,
  std,
}: let
  inherit (conf) username colorscheme virtualization zram;
  inherit (lib) optional;
in {
  imports =
    [
      (
        if conf.boot.loader == "systemd-boot"
        then (import ./bootloader/systemd-boot/default.nix)
        else (import ./bootloader/grub/default.nix)
      )
      (
        if conf ? shell && conf.shell == "fish"
        then (import ./shell/fish/default.nix {inherit username pkgs;})
        else if conf ? shell && conf.shell == "zsh"
        then (import ./shell/zsh/default.nix {inherit username pkgs colorscheme;})
        else (import ./shell/bash/default.nix {inherit username pkgs;})
      )
    ]
    ++ optional virtualization (import ./virtualization/default.nix {inherit username;})
    ++ optional zram ./zram/default.nix;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nb" ''
      command "$@" > /dev/null 2>&1 &
      disown
    '')
  ];
}
