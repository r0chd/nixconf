{ conf, lib }:
let inherit (conf) username;
in {
  options.virtualisation.enable = lib.mkEnableOption "Enable virtualisation";

  config = lib.mkIf conf.virtualisation.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    programs.virt-manager.enable = true;
    users.users."${username}".extraGroups = [ "libvirtd" ];
  };
}
