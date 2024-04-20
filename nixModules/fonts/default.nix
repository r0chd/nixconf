{pkgs, ...}: {
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];
}
