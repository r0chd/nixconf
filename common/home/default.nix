{ ... }:
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        laptop.id = "F265KCD-YJPGOI2-SZJT5TH-FNDPNGU-S7CZGD6-75VIYU4-KN4OPOP-TVGCCQM";
        laptop-huawei.id = "BWGC6UT-LQGJXRT-3F7XYUO-7TZC6PL-JEHXAJN-Z7YL3SD-DB2B5N2-N6THWQL";
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
