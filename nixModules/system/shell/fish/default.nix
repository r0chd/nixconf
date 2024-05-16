{
  pkgs,
  username,
  ...
}: {
  imports = [(import ./home.nix {inherit username pkgs;})];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
}
