{
  pkgs,
  username,
  ...
}: {
  imports = [(import ./home.nix {inherit username;})];
  users.defaultUserShell = pkgs.bash;
  home-manager.users."${username}".programs.bash = {
    enable = true;
  };
}
