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
      historyFile = "${config.home.homeDirectory}/.bash_history";
      historyFileSize = 10000;
    };
  };
}
