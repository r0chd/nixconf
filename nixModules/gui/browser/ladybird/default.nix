{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [ladybird];
    shellAliases.ladybird = "Ladybird";
  };
}
