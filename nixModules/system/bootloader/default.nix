{grub, ...}: {
  imports = [
    (
      if grub == true
      then ./grub/default.nix
      else ./systemd-boot/default.nix
    )
  ];
}
