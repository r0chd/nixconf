{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib;
with types;
let
  cfg = config.programs.tuigreet;
in
{
  options.programs.tuigreet = {
    enable = mkEnableOption "Enable tuigreet";
    package = mkOption {
      description = "Tuigreet package";
      type = package;
      default = pkgs.greetd.tuigreet;
    };
    width = lib.mkOption {
      description = "Width of the main prompt";
      type = int;
      default = 80;
    };
    windowPadding = lib.mkOption {
      description = "Padding inside the terminal area";
      type = int;
      default = 0;
    };
    containerPadding = lib.mkOption {
      description = "Padding inside the main prompt container";
      type = int;
      default = 1;
    };
    promptPadding = lib.mkOption {
      description = "Padding between prompt rows";
      type = int;
      default = 1;
    };
    debug = {
      enable = mkEnableOption "Enable debug logging to the provided file";
      file = mkOption {
        description = "Debug logging output file";
        type = path;
        default = /tmp/tuigreet.log;
      };
    };
    issue = mkEnableOption "Show the host's issue file";
    session = {
      paths = mkOption {
        description = "List of Wayland session paths";
        type = listOf path;
        default = [ ];
      };
      wrapper = mkOption {
        description = "Wrapper command for non-X11 sessions";
        type = str;
        default = "";
      };
    };
    xsession = {
      paths = mkOption {
        description = "List of X11 session paths";
        type = listOf path;
        default = [ ];
      };
      wrapper = mkOption {
        description = "Wrapper command for X11 sessions";
        type = str;
        default = "";
      };
      disable = mkEnableOption "Disable X11 session wrapping";
    };
    command = {
      cmd = mkOption {
        description = "Command to run";
        default = "";
        type = str;
      };
      key = mkOption {
        description = "F-key to use to open the command menu [1-12]";
        default = 1;
        type = ints.between 1 12;
      };
    };
    time = {
      enable = mkEnableOption "Display the current date and time";
      format = mkOption {
        description = "Custom strftime format for displaying date and time";
        default = "HH:MM";
        type = str;
      };
    };
    greeting = {
      enable = mkEnableOption "Show custom text above login prompt";
      text = mkOption {
        description = "Text above login prompt";
        default = "Welcome back!";
        type = str;
      };
      align = mkOption {
        description = "Alignment of the greeting text in the main prompt container";
        default = "center";
        type = enum [
          "left"
          "center"
          "right"
        ];
      };
    };
    asterisks = {
      enable = mkEnableOption "Display asterisks when a secret is typed";
      char = mkOption {
        description = "Characters to be used to redact secrets";
        default = "*";
        type = str;
      };
    };
    session = {
      remember = mkEnableOption "Remember last selected session";
      key = mkOption {
        description = "F-key to use to open the sessions menu [1-12]";
        default = 3;
        type = ints.between 1 12;
      };
    };
    user = {
      menu = {
        enable = mkEnableOption "Allow graphical selection of users from a menu";
        minUid = mkOption {
          description = "Minimum UID to display in the user selection menu";
          default = null;
          type = nullOr int;
        };
        maxUid = mkOption {
          description = "Maximum UID to display in the user selection menu";
          default = null;
          type = nullOr int;
        };
      };
      rememberSession = mkEnableOption "Remember last selected session for each user";
      remember = mkEnableOption "Remember last logged-in username";
    };
    power = {
      key = mkOption {
        description = "F-key to use to open the power menu [1-12]";
        default = 12;
        type = ints.between 1 12;
      };
      shutdown = mkOption {
        description = "Command to run to shut down the system";
        default = "";
        type = str;
      };
      reboot = mkOption {
        description = "Command to run to reboot the system";
        default = "";
        type = str;
      };
      noSetsid = mkEnableOption "Do not prefix power commands with setsid";
    };
  };

  config = mkIf cfg.enable {
    environment.persist.directories = [ "/var/cache/tuigreet" ];

    services.greetd.settings.default_session = {
      user = mkDefault "greeter";
      command = mkDefault (
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
        + optionalString cfg.time.enable " -t --time-format \"${cfg.time.format}\""
        + optionalString cfg.asterisks.enable " --asterisks --asterisks-char \"${cfg.asterisks.char}\""
        + optionalString cfg.user.menu.enable " --user-menu"
        + optionalString cfg.session.remember " --remember-session"
        + optionalString cfg.user.remember " --remember"
        + optionalString cfg.user.rememberSession " --remember-user-session"
        + optionalString cfg.greeting.enable " -g \"${cfg.greeting.text}\" --greet-align \"${cfg.greeting.align}\""
        + optionalString cfg.power.noSetsid " --power-no-setsid"
        + optionalString cfg.issue " -i"
        + optionalString cfg.xsession.disable " --no-xsession-wrapper"
        + optionalString cfg.debug.enable " -d \"${toString cfg.debug.file}\""
        + optionalString (
          cfg.user.menu.minUid != null
        ) " --user-menu-min-uid ${toString cfg.user.menu.minUid}"
        + optionalString (
          cfg.user.menu.maxUid != null
        ) " --user-menu-max-uid ${toString cfg.user.menu.maxUid}"
      );
    };
  };
}

# TODO: do the theme and session paths as well as xsession paths
