{ conf, pkgs, lib }:
let inherit (conf) hostname;
in {
  options.wireless.enable =
    lib.mkEnableOption "Enable wireless wifi connection";

  config = lib.mkIf conf.wireless.enable {
    networking = {
      wireless.iwd = { enable = true; };
      hostName = "${hostname}";
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };

    environment.systemPackages = with pkgs; [
      wirelesstools
      traceroute
      inetutils
    ];
  };
}
