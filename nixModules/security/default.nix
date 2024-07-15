{
  conf,
  inputs,
  pkgs,
  helpers,
}: let
  inherit (conf) username hostname;
in {
  imports = [(import ./sops/default.nix {inherit username inputs pkgs hostname helpers;})];

  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["${username}"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = true;
    rtkit.enable = true;
  };
}
