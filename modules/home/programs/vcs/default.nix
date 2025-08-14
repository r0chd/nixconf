{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.programs.vcs;
in
{
  imports = [
    ./git
    ./jj
  ];

  options.programs.vcs = {
    identityFile = lib.mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };
    signingKeyFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    email = lib.mkOption { type = types.nullOr lib.types.str; };
  };

  config.programs.ssh.matchBlocks = lib.mkIf (cfg.identityFile != null) {
    "git" = {
      host = "github.com";
      user = "git";
      forwardAgent = true;
      identitiesOnly = true;
      inherit (cfg) identityFile;
    };
  };
}
