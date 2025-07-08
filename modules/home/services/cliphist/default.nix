{ profile, ... }:
{
  services.cliphist = {
    enable = profile == "desktop";
  };
}
