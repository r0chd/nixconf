{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zoxide
  ];
}
