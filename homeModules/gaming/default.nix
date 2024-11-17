{ lib, ... }: {
  options.gaming = {
    heroic.enable = lib.mkEnableOption "Enable heroic launcher";
    steam.enable = lib.mkEnableOption "Enable steam";
    lutris.enable = lib.mkEnableOption "Enable lutris";
    minecraft.enable = lib.mkEnableOption "Enable minecraft";
  };

  imports = [ ./heroic ./steam ./lutris ./minecraft ];
}
