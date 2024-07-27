{
  conf,
  pkgs,
  lib,
  config,
  std,
  inputs,
}: let
  inherit (conf) username colorscheme font tmux seto nh zoxide man lsd bat direnv nix-index;
  inherit (lib) optional;
  shell =
    if conf ? shell
    then conf.shell
    else "bash";
in {
  imports =
    [
      (import ./git {inherit username config std;})
    ]
    ++ optional (conf ? email)
    (import ./msmtp {
      inherit config username lib;
      email = conf.email;
    })
    ++ (
      if conf ? terminal && conf.terminal == "kitty"
      then [(import ./kitty {inherit username font;})]
      else if conf ? terminal && conf.terminal == "foot"
      then [(import ./foot {inherit username font;})]
      else []
    )
    ++ optional (conf ? editor && conf.editor == "nvim") (import ./nvim {inherit pkgs username colorscheme inputs;})
    ++ optional tmux (import ./tmux {inherit pkgs conf;})
    ++ optional seto (import ./seto {inherit conf pkgs inputs;})
    ++ optional nh (import ./nh {inherit username pkgs std;})
    ++ optional zoxide (import ./zoxide {inherit username shell;})
    ++ optional man (import ./man {inherit pkgs;})
    ++ optional lsd (import ./lsd {inherit username;})
    ++ optional bat (import ./bat {inherit username;})
    ++ optional direnv (import ./direnv {inherit username shell;})
    ++ optional nix-index (import ./nix-index {inherit username;});
}
