{ lib, ... }: {
  options = {
    gaming = {
      heroic.enable = lib.mkEnableOption "Enable heroic launcher";
      steam.enable = lib.mkEnableOption "Enable steam";
      lutris.enable = lib.mkEnableOption "Enable lutris";
    };
  };

  imports = [ ./heroic ./steam ./lutris ];
}
