{
  userConfig,
  inputs,
  pkgs,
}: let
  inherit (userConfig) username;
in {
  imports = [(import ./sops/default.nix {inherit username inputs pkgs;})];

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
