{ pkgs, config, ... }:
let
  app = "myApp";
  appDomain = "myapp.com";
  dataDir = "/var/www/${app}/html";
in
{

  services.phpfpm.pools.${app} = {
    user = app;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
      "listen.mode" = "0660";
      "catch_workers_output" = 1;
    };
  };

  users.groups.${app}.members = [ "${app}" ];
  users.users.${app} = {
    isSystemUser = true;
    group = "${app}";
  };
  users.users.nginx.extraGroups = [ "${app}" ];

  services.nginx = {
    enable = true;

    virtualHosts = {
      ${appDomain} = {
        root = "${dataDir}";

        extraConfig = ''
          index index.php;
        '';

        locations."~ ^(.+\\.php)(.*)$" = {
          extraConfig = ''
            # Check that the PHP script exists before passing it
            try_files $fastcgi_script_name =404;
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_split_path_info  ^(.+\.php)(.*)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            fastcgi_param  PATH_INFO        $fastcgi_path_info;

            include ${pkgs.nginx}/conf/fastcgi.conf;            
          '';
        };
      };
    };
  };
}
