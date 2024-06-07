{config, ...}: let
  inherit (config) username;
in {
  home-manager.users."${username}" = {
    home = {
      homeDirectory = "/home/${username}";
      username = "${username}";
      stateVersion = "23.11";
    };
    programs = {
      home-manager.enable = true;
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
