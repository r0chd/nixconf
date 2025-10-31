{
  lib,
  systemUsers,
  config,
  ...
}:
{
  imports = [
    ./nh
    ./git
    ./nixos-anywhere
  ];

  programs = {
    less.lessopen = null;
    command-not-found.enable = false;
    fish.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
  };

  users.users = (
    systemUsers
    |> lib.mapAttrs (
      _user: value: {
        extraGroups = lib.mkIf (
          value.root.enable
          && config.programs.nixos-anywhere.enable
          && config.programs.nixos-anywhere.sshKeyFile != null
        ) [ "nixos-anywhere" ];
      }
    )
  );
}
