{ pkgs, inputs, config, lib, ... }: {
  config =
    lib.mkIf (config.terminal.enable && config.terminal.program == "ghostty") {
      environment.systemPackages = with pkgs;
        [ inputs.ghostty.packages.${system}.default ];

      home-manager.users."${config.username}".home.file.".config/ghostty/config".text =
        ''
          font-size = 10
          font-family = "${config.font}"

          window-decoration = false

          background-opacity = 0.0
          background = #000000

          confirm-close-surface = false
        '';
    };
}
