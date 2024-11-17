{ username, lib, config, ... }: {
  options.root = lib.mkOption {
    type = lib.types.enum [ "sudo" "doas" ];
    default = "sudo";
  };

  config.security = {
    doas = lib.mkIf (config.root == "doas") {
      enable = true;
      extraRules = [{
        users = [ "${username}" ];
        keepEnv = true;
        persist = true;
      }];
    };
    sudo.enable = (config.root == "sudo");
    rtkit.enable = true;
    polkit.enable = true;
  };
}
