{ inputs, pkgs, ... }:
{
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;
    flake = "/var/lib/nixconf";
  };
  environment.sessionVariables.NH_NOTIFY = 1;
}
