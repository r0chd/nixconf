{ pkgs, ... }:
{
  networking.nameservers = [ "192.168.30.102" ];

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [ helix ];
  };
}
