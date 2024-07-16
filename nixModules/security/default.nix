{
  conf,
  inputs,
  pkgs,
  std,
}: let
  inherit (conf) username hostname;
in {
  imports = [(import ./sops/default.nix {inherit username inputs pkgs hostname std;})];

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
