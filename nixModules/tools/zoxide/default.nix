{
  pkgs,
  username,
  shell,
  ...
}: {
  imports = [(import ./home.nix {inherit username pkgs shell;})];
  environment = {
    systemPackages = with pkgs; [
      zoxide
    ];
  };
}
