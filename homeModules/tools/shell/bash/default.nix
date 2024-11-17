{ config, lib, ... }: {
  config =
    lib.mkIf (config.shell == "bash") { programs.bash = { enable = true; }; };
}
