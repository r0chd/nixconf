{
  lib,
  shell,
  config,
  ...
}:
{
  config = lib.mkIf (shell == "bash") {
    programs.bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignoreboth"
      ];
      historyFile = "/home/${config.home.username}/.bash_history";
      historyFileSize = 10000;
    };
  };
}
