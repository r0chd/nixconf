# For lanzaboote to work you must first:
# - NixOs must be installed in UEFI mode
# - use systemd-boot (wont work with grub)
# - create secure boot keys with `sudo sbctl create-keys`
# Also optionally (but very stupid to not do that):
# - Have setup bios password
# - Use full disc encryption
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.system.bootloader;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  config = lib.mkIf (cfg.variant == "lanzaboote") {
    environment.systemPackages = with pkgs; [ sbctl ];

    boot.lanzaboote = {
      enable = true;
      pkiBundle =
        if config.system.impermanence.enable then "/persist/system/etc/secureboot" else "/etc/secureboot";
    };

    system.impermanence.persist.directories = [ "/etc/secureboot" ];
  };
}
