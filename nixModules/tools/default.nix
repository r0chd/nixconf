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
      (import ./git/home.nix {inherit username config std;})
    ]
    ++ optional (conf ? email)
    (import ./msmtp/default.nix {
      inherit config username lib;
      email = conf.email;
    })
    ++ (
      if conf ? terminal && conf.terminal == "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if conf ? terminal && conf.terminal == "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ optional (conf ? editor && conf.editor == "nvim") (import ./nvim/default.nix {inherit pkgs username colorscheme inputs;})
    ++ optional tmux (import ./tmux/home.nix {inherit pkgs username shell colorscheme;})
    ++ optional seto (import ./seto/home.nix {inherit colorscheme username font pkgs inputs;})
    ++ optional nh (import ./nh/default.nix {inherit username pkgs std;})
    ++ optional zoxide (import ./zoxide/default.nix {inherit username shell;})
    ++ optional man (import ./man/default.nix {inherit pkgs;})
    ++ optional lsd (import ./lsd/default.nix {inherit username;})
    ++ optional bat (import ./bat/default.nix {inherit username;})
    ++ optional direnv (import ./direnv/default.nix {inherit username shell;})
    ++ optional nix-index (import ./nix-index/default.nix {inherit username;});
}
