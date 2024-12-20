{
  lib,
  shell,
  ...
}:
{
  config = lib.mkIf (shell == "bash") {
    programs.bash = {
      enable = true;
    };
  };
}
