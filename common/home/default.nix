{ ... }:
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        laptop.id = "F265KCD-YJPGOI2-SZJT5TH-FNDPNGU-S7CZGD6-75VIYU4-KN4OPOP-TVGCCQM";
        laptop-huawei.id = "BEPHLDU-U4RLH7V-7YLQOBN-L2IX2B2-OBJV5SP-MZMEHLF-PI7VFUQ-F2X5VQO";
        laptop-lenovo.id = "C5GUBSH-TR5VRA4-F33RW3V-3GOA7KC-R2CKVNS-2BT7EJW-44CBERS-OELDGAJ";
        laptop-thinkpad.id = "4G25JBC-D5FCDQR-TAVZASY-SS5Y2UV-JHCGHIJ-FIE4AXO-WJOQP6C-MKDKKAV";
      };
      folders = {
        "/var/lib/nixconf" = {
          path = "/var/lib/nixconf";
          devices = [
            "laptop"
            "laptop-lenovo"
            "laptop-huawei"
            "laptop-thinkpad"
          ];
        };
      };
    };
  };
}
