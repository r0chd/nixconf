{
  pkgs,
  username,
  ...
}: {
  imports = [(import ./home.nix {inherit username;})];
  users.defaultUserShell = pkgs.bash;
}
