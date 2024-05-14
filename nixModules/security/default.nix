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
    sudo.enable = true;
    rtkit.enable = true;
  };
}
