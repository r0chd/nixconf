{
  username,
  pkgs,
}: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  programs.virt-manager.enable = true;
  users.users."${username}".extraGroups = ["libvirtd"];
}
