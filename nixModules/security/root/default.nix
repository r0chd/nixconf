{ ... }:
{
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = "Defaults rootpw";
  };
}
