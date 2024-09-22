{conf}: let
  inherit (conf) username;
in {
  security.pam.services.hyprlock = {};
  home-manager.users."${username}".programs.hyprlock = {
    enable = true;
  };
}
