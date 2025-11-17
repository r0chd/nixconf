{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tuigreet;
in
{
  options.programs.tuigreet = {
    enable = lib.mkEnableOption "Enable tuigreet";
    package = lib.mkOption {
      description = "Tuigreet package";
      type = lib.types.package;
      default = pkgs.tuigreet;
    };
    width = lib.mkOption {
      description = "Width of the main prompt";
      type = lib.types.int;
      default = 80;
    };
    windowPadding = lib.mkOption {
      description = "Padding inside the terminal area";
      type = lib.types.int;
      default = 0;
    };
    containerPadding = lib.mkOption {
      description = "Padding inside the main prompt container";
      type = lib.types.int;
      default = 1;
    };
    promptPadding = lib.mkOption {
      description = "Padding between prompt rows";
      type = lib.types.int;
      default = 1;
    };
    debug = {
      enable = lib.mkEnableOption "Enable debug logging to the provided file";
      file = lib.mkOption {
        description = "Debug logging output file";
        type = lib.types.path;
        default = /tmp/tuigreet.log;
      };
    };
    issue = lib.mkEnableOption "Show the host's issue file";
    session = {
      paths = lib.mkOption {
        description = "List of Wayland session paths";
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
      wrapper = lib.mkOption {
        description = "Wrapper command for non-X11 sessions";
        type = lib.types.str;
        default = "";
      };
    };
    xsession = {
      paths = lib.mkOption {
        description = "List of X11 session paths";
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
      wrapper = lib.mkOption {
        description = "Wrapper command for X11 sessions";
        type = lib.types.str;
        default = "";
      };
      disable = lib.mkEnableOption "Disable X11 session wrapping";
    };
    command = {
      cmd = lib.mkOption {
        description = "Command to run";
        default = "";
        type = lib.types.str;
      };
      key = lib.mkOption {
        description = "F-key to use to open the command menu [1-12]";
        default = 1;
        type = lib.types.ints.between 1 12;
      };
    };
    time = {
      enable = lib.mkEnableOption "Display the current date and time";
      format = lib.mkOption {
        description = "Custom strftime format for displaying date and time";
        default = "HH:MM";
        type = lib.types.str;
      };
    };
    greeting = {
      enable = lib.mkEnableOption "Show custom text above login prompt";
      text = lib.mkOption {
        description = "Text above login prompt";
        default = "Welcome back!";
        type = lib.types.str;
      };
      align = lib.mkOption {
        description = "Alignment of the greeting text in the main prompt container";
        default = "center";
        type = lib.types.enum [
          "left"
          "center"
          "right"
        ];
      };
    };
    asterisks = {
      enable = lib.mkEnableOption "Display asterisks when a secret is typed";
      char = lib.mkOption {
        description = "Characters to be used to redact secrets";
        default = "*";
        type = lib.types.str;
      };
    };
    session = {
      remember = lib.mkEnableOption "Remember last selected session";
      key = lib.mkOption {
        description = "F-key to use to open the sessions menu [1-12]";
        default = 3;
        type = lib.types.ints.between 1 12;
      };
    };
    user = {
      menu = {
        enable = lib.mkEnableOption "Allow graphical selection of users from a menu";
        minUid = lib.mkOption {
          description = "Minimum UID to display in the user selection menu";
          default = null;
          type = lib.types.nullOr lib.types.int;
        };
        maxUid = lib.mkOption {
          description = "Maximum UID to display in the user selection menu";
          default = null;
          type = lib.types.nullOr lib.types.int;
        };
      };
      rememberSession = lib.mkEnableOption "Remember last selected session for each user";
      remember = lib.mkEnableOption "Remember last logged-in username";
    };
    power = {
      key = lib.mkOption {
        description = "F-key to use to open the power menu [1-12]";
        default = 12;
        type = lib.types.ints.between 1 12;
      };
      shutdown = lib.mkOption {
        description = "Command to run to shut down the system";
        default = "";
        type = lib.types.str;
      };
      reboot = lib.mkOption {
        description = "Command to run to reboot the system";
        default = "";
        type = lib.types.str;
      };
      noSetsid = lib.mkEnableOption "Do not prefix power commands with setsid";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persist.directories = [ "/var/cache/tuigreet" ];

    services.greetd.settings.default_session = {
      user = lib.mkDefault "greeter";
      command = lib.mkDefault (
        ''
          ${cfg.package}/bin/tuigreet \
                        --power-shutdown "${cfg.power.shutdown}" \
                        --power-reboot "${cfg.power.reboot}" \
                        --kb-power ${toString cfg.power.key} \
                        --kb-sessions ${toString cfg.session.key} \
                        --kb-command ${toString cfg.command.key} \
                        -c "${cfg.command.cmd}" \
                        --session-wrapper "${cfg.session.wrapper}" \
                        --xsession-wrapper "${cfg.xsession.wrapper}" \
                        -w ${toString cfg.width} \
                        --window-padding ${toString cfg.windowPadding} \
                        --container-padding ${toString cfg.containerPadding} \
                        --prompt-padding ${toString cfg.promptPadding} \
        ''
        + lib.optionalString cfg.time.enable " -t --time-format \"${cfg.time.format}\""
        + lib.optionalString cfg.asterisks.enable " --asterisks --asterisks-char \"${cfg.asterisks.char}\""
        + lib.optionalString cfg.user.menu.enable " --user-menu"
        + lib.optionalString cfg.session.remember " --remember-session"
        + lib.optionalString cfg.user.remember " --remember"
        + lib.optionalString cfg.user.rememberSession " --remember-user-session"
        + lib.optionalString cfg.greeting.enable " -g \"${cfg.greeting.text}\" --greet-align \"${cfg.greeting.align}\""
        + lib.optionalString cfg.power.noSetsid " --power-no-setsid"
        + lib.optionalString cfg.issue " -i"
        + lib.optionalString cfg.xsession.disable " --no-xsession-wrapper"
        + lib.optionalString cfg.debug.enable " -d \"${toString cfg.debug.file}\""
        + lib.optionalString (
          cfg.user.menu.minUid != null
        ) " --user-menu-min-uid ${toString cfg.user.menu.minUid}"
        + lib.optionalString (
          cfg.user.menu.maxUid != null
        ) " --user-menu-max-uid ${toString cfg.user.menu.maxUid}"
      );
    };
  };
}

# TODO: do the theme and session paths as well as xsession paths
