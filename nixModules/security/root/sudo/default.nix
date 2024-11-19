{ config, lib, ... }:
{
  config = lib.mkIf (config.root == "sudo") {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = "Defaults rootpw";
    };
  };
}
