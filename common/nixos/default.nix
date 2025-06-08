{ pkgs, ... }:
{
  networking.nameservers = [
    "192.168.30.102"
    "1.1.1.1"
    "1.0.0.1"
  ];

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [ helix ];
  };
}
