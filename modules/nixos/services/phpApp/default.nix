{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.phpApp;
  mkPhpApp = appName: {
    services = {
      phpfpm.pools.${appName} = {
        user = appName;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.max_requests" = 500;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 5;
        };
      };

      nginx = {
        enable = true;
        virtualHosts."${appName}.example.com" = {
          serverName = "localhost";
          root = "/var/www/${appName}";

          locations."/" = {
            index = "index.php index.html";
            tryFiles = "$uri $uri/ /index.php$is_args$args";
          };

          locations."~ \.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${appName}.socket};
              fastcgi_index index.php;
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
        };
      };
    };

    system.activationScripts.foo_home_read = pkgs.lib.stringAfter [ "users" ] ''
      chown -R ${appName}:wheel /var/www/${appName}
      chmod -R 664 /var/www/${appName}
    '';

    users = {
      users.${appName} = {
        isSystemUser = true;
        createHome = true;
        home = "/var/www/${appName}";
        group = appName;
      };
      groups.${appName} = { };
    };
  };
in
{
  options.services.phpApp = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule { });
    default = { };
  };

  #  config = { } // mkPhpApp "phpdemo" // mkPhpApp "phptest";
}
