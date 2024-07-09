{
  userConfig,
  pkgs,
  lib,
  helpers,
}: let
  inherit (userConfig) username colorscheme;
  inherit (lib) optional;
in {
  imports =
    [
      (
        if helpers.checkAttribute "bootloader" "systemd-boot"
        then ./bootloader/systemd-boot/default.nix
        else ./bootloader/grub/default.nix
      )
      (
        if helpers.checkAttribute "shell" "fish"
        then (import ./shell/fish/default.nix {inherit username pkgs;})
        else if helpers.checkAttribute "shell" "zsh"
        then (import ./shell/zsh/default.nix {inherit username pkgs colorscheme;})
        else (import ./shell/bash/default.nix {inherit username pkgs;})
      )
    ]
    ++ optional (!helpers.isDisabled "virtualization") (import ./virtualization/default.nix {inherit username;});

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nb" ''
      command "$@" > /dev/null 2>&1 &
      disown
    '')
  ];
}
