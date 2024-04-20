{...}: {
  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["unixpariah"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = false;
    rtkit.enable = true;
  };
}
