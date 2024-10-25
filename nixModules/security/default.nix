{ conf, inputs, std, pkgs }:
let inherit (conf) username hostname;
in {
  imports = [ (import ./sops { inherit inputs hostname std pkgs; }) ];

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
