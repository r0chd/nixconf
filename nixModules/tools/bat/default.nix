{pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.bat];
    shellAliases = {cat = "bat";};
  };
}
