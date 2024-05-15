{...}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.unixpariah.extraGroups = ["libvirtd"];
}
