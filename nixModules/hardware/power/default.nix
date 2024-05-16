_: {
  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    thermald.enable = true;
  };

  powerManagement.enable = true;
}
