{ std, config, lib, ... }: {
  options.sops = {
    enable = lib.mkEnableOption "sops";
    managePassword = lib.mkEnableOption "manage passwords with sops";
  };

  config = lib.mkIf config.sops.enable {
    sops = { # TODO: make this apply for each user password
      defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
      secrets.password.neededForUsers =
        lib.mkIf config.sops.managePassword true;
    };
  };
}
