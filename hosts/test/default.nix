{ lib, utils, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    bootloader.legacy = false;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  systemd.services =
    let
      mkImmutableService =
        { filePath, persistentStoragePath, ... }@args:
        let
          targetFile = lib.concatPaths [
            persistentStoragePath
            filePath
          ];
          mountPoint = lib.escapeShellArg filePath;
        in
        {
          "persist-${utils.escapeSystemdPath targetFile}" = {
            description = "Bind mount or link ${targetFile} to ${mountPoint}";
            wantedBy = [ "local-fs.target" ];
            before = [ "local-fs.target" ];
            path = [ pkgs.util-linux ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = mkPersistFile args;
              ExecStop = pkgs.writeShellScript "unbindOrUnlink-${escapeSystemdPath targetFile}" ''
                set -eu
                if [[ -L ${mountPoint} ]]; then
                    rm ${mountPoint}
                else
                    umount ${mountPoint}
                    rm ${mountPoint}
                fi
              '';
            };
          };
        };
    in
    foldl' recursiveUpdate { } (map mkPersistFileService files);
}
