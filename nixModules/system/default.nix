{
  userConfig,
  pkgs,
  lib,
}: let
  inherit (userConfig) shell bootloader username colorscheme;
  isDisabled = attribute: lib.hasAttr attribute userConfig && userConfig.tmux == false;
in {
  imports =
    [
      (
        if bootloader == "grub"
        then ./bootloader/grub/default.nix
        else if bootloader == "systemd-boot"
        then ./bootloader/systemd-boot/default.nix
        else []
      )
      (
        if shell == "fish"
        then (import ./shell/fish/default.nix {inherit username pkgs;})
        else if shell == "zsh"
        then (import ./shell/zsh/default.nix {inherit username pkgs colorscheme;})
        else
          (
            import ./shell/bash/default.nix {inherit username pkgs;}
          )
      )
    ]
    ++ (
      if isDisabled "virtualization"
      then []
      else [(import ./virtualization/default.nix {inherit username;})]
    );

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nb" ''
      command "$@" > /dev/null 2>&1 &
      disown
    '')
  ];
}
