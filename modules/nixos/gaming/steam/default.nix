{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gaming.steam;
in
{
  options.gaming.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        (pkgs.writeShellScriptBin "steamos-session-select" ''
          steam -shutdown
        '')
      ];

      persist.users.directories = [
        ".steam"
        "Games/Steam"
        ".local/share/Steam"
      ];
    };

    programs.steam = {
      enable = true;
      protontricks.enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    boot.kernel.sysctl = {
      # 20-shed.conf
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      # 20-net-timeout.conf
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too large.
      "net.ipv4.tcp_fin_timeout" = 5;
      # 30-splitlock.conf
      # Prevents intentional slowdowns in case games experience split locks
      # This is valid for kernels v6.0+
      "kernel.split_lock_mitigate" = 0;
      # 30-vm.conf
      # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # see comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };
  };
}
