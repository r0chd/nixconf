{ conf, inputs, std, pkgs, lib, config }:
let inherit (conf) username;
in {
  imports = [ (import ./sops { inherit inputs conf std pkgs lib config; }) ];

  security = {
    doas = {
      enable = true;
      extraRules = [{
        users = [ "${username}" ];
        keepEnv = true;
        persist = true;
      }];
    };
    sudo.enable = true;
    rtkit.enable = true;
  };
}
