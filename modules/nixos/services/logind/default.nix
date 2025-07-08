{ profile, lib, ... }:
{
  services.logind = lib.mkIf (profile == "server") {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=ignore
      HandleSuspendKey=ignore
    '';
  };
}
