{ pkgs, inputs, conf, lib }:
let inherit (conf) username font;
in {
  config =
    lib.mkIf (conf.terminal.enable && conf.terminal.program == "ghostty") {
      environment.systemPackages = with pkgs;
        [ inputs.ghostty.packages.${system}.default ];

      home-manager.users."${username}".home.file.".config/ghostty/config".text =
        ''
          font-size = 10
          font-family = "${font}"

          window-decoration = false

          background-opacity = 0.0
          background = #000000

          confirm-close-surface = false
        '';
    };
}
