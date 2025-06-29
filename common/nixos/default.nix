{ pkgs, ... }:
{
  imports = [ ./ssh.nix ];

  networking.nameservers = [ "1.1.1.1" ];

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [ helix ];
  };
}
