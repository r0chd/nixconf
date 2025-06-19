{ system_type, ... }:
{
  services.cliphist = {
    enable = (system_type == "desktop");
  };
}
