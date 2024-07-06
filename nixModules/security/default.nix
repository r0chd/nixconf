{
  userConfig,
  inputs,
  pkgs,
}: let
  inherit (userConfig) username hostname;
in {
  imports = [(import ./sops/default.nix {inherit username inputs pkgs hostname;})];

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
