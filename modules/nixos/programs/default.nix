{
  lib,
  profile,
  systemUsers,
  config,
  ...
}:
{
  imports = [
    ./nh
    ./git
    ./deploy-rs
  ];

  programs = {
    less.lessopen = null;
    command-not-found.enable = false;
    fish.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
    captive-browser = lib.mkIf (config.networking.wireless.mainInterface != null) {
      enable = profile == "desktop";
      interface = config.networking.wireless.mainInterface;
    };
  };

  users.users =
    systemUsers
    |> lib.mapAttrs (
      user: value: {
        extraGroups = lib.mkIf (
          value.root.enable
          && config.programs.deploy-rs.enable
          && config.programs.deploy-rs.sshKeyFile != null
        ) [ "deploy-rs" ];
      }
    );
}
