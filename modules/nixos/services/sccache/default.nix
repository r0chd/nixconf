{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sccache;
  inherit (lib) types;
in
{
  imports = [
    ./builder.nix
    ./scheduler.nix
  ];

  options.services.sccache = {
    enable = lib.mkEnableOption "sccache";
    package = lib.mkOption {
      type = types.package;
      default = pkgs.sccache.override { distributed = true; };
      description = "sccache package with optional dist support";
    };
    bwrapPackage = lib.mkPackageOption pkgs "bubblewrap" { };

    cacheDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/sccache/cache";
      description = "Directory for sccache cache";
    };

    buildDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/sccache/build";
      description = "Directory for build operations";
    };

    #auth = {
    #  token = lib.mkOption {
    #    type = types.str;
    #    default = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjAsInNlcnZlcl9pZCI6IjEyNy4wLjAuMToxMDUwMSJ9.5XwRfN4GP6JjYoNq-uIv8EdJBhNa2vIJZynGbtOGD2g";
    #    description = "Authentication token (JWT format)";
    #  };

    #  jwtSecret = lib.mkOption {
    #    type = types.str;
    #    default = "f561c77ee065d64eb7c048d022b803e91ece20e12c12222be45fa9108e30944662de07b441931e2311003ac71490a061079b1614b5efa18507aaaa6f6ed3faff";
    #    description = "JWT secret key";
    #  };
    #};
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.rules = [
        "d ${cfg.cacheDir} 0755 root root"
        "d ${cfg.buildDir} 0755 root root"
      ];
    };

    environment = {
      sessionVariables.RUSTC_WRAPPER = "${cfg.package}/bin/sccache";
      systemPackages = [ cfg.package ];
    };
  };
}
