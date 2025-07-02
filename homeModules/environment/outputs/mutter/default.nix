{ config, lib, ... }:
let
  # This is just so that monitorSpec values can be in
  # a single line (it looks prettier)
  option = cond: val: lib.optionalString cond val;

  toLogicalMonitor = name: cfg: ''
    <logicalmonitor>
      <x>${toString cfg.position.x}</x>
      <y>${toString cfg.position.y}</y>
      <scale>${toString cfg.scale}</scale>
      ${if cfg.primary then "<primary>yes</primary>" else ""}
      <monitor>
        <monitorspec>
          <connector>${name}</connector>
          ${option (cfg.monitorSpec.vendor != null) "<vendor>${cfg.monitorSpec.vendor}</vendor>"}
          ${option (cfg.monitorSpec.product != null) "<product>${cfg.monitorSpec.product}</product>"}
          ${option (cfg.monitorSpec.serial != null) "<serial>${cfg.monitorSpec.serial}</serial>"}
        </monitorspec>
        <mode>
          <width>${toString cfg.dimensions.width}</width>
          <height>${toString cfg.dimensions.height}</height>
          <rate>${toString cfg.refresh}</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  '';

  xmlContent = lib.concatStringsSep "\n" (
    lib.mapAttrsToList toLogicalMonitor config.environment.outputs
  );
in
{
  config = lib.mkIf config.programs.gnome.enable {
    xdg.configFile."monitors.xml".text = ''
      <monitors version="2">
        <configuration>
          ${xmlContent}
        </configuration>
      </monitors>
    '';
  };
}
