{ pkgs, hostname, ... }:
{
  imports = [
    ./wireless
    ./ssh
  ];

  networking.hostName = hostname;

  networking.hostFiles =
    let
      tailscaleHostsScript = pkgs.writeShellScript "generate_tailscale_hosts" ''
        ${pkgs.tailscale}/bin/tailscale status | ${pkgs.gawk}/bin/awk '{print $1, $2}' > /tmp/tailscale_hosts
        cat /tmp/tailscale_hosts
      '';
    in
    [
      (builtins.toString (
        pkgs.runCommand "tailscale-hosts" { } ''
          ${tailscaleHostsScript} > $out
        ''
      ))
    ];

  boot.initrd = {
    #network.enable = true;
    availableKernelModules = [ "alx" ];
    kernelModules = [
      "vfat"
      "nls_cp437"
      "nls_iso8859-1"
      "usbhid"
      "alx"
    ];
  };
}
