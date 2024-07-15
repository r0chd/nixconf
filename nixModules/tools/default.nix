{
  conf,
  pkgs,
  lib,
  config,
  helpers,
  inputs,
}: let
  inherit (conf) username colorscheme font editor tmux seto nh zoxide man lsd bat direnv nix-index;
  inherit (lib) optional hasAttr;
  shell = lib.mkDefault (
    if hasAttr "shell" conf
    then conf.shell
    else "bash"
  );
in {
  imports =
    [
      (import ./git/home.nix {inherit username config helpers;})
    ]
    ++ optional (hasAttr "email" conf)
    (import ./msmtp/default.nix {
      inherit config username lib;
      email = conf.email;
    })
    ++ (
      if hasAttr "terminal" conf && conf.terminal == "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if hasAttr "terminal" conf && conf.terminal == "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ optional (editor == "nvim") (import ./nvim/default.nix {inherit pkgs username colorscheme inputs;})
    ++ optional tmux (import ./tmux/home.nix {inherit pkgs username shell colorscheme;})
    ++ optional seto (import ./seto/home.nix {inherit colorscheme username font pkgs inputs;})
    ++ optional nh (import ./nh/default.nix {inherit username pkgs helpers;})
    ++ optional zoxide (import ./zoxide/default.nix {inherit username shell;})
    ++ optional man (import ./man/default.nix {inherit pkgs;})
    ++ optional lsd (import ./lsd/default.nix {inherit username;})
    ++ optional bat (import ./bat/default.nix {inherit username;})
    ++ optional direnv (import ./direnv/default.nix {inherit username shell;})
    ++ optional nix-index (import ./nix-index/default.nix {inherit username;});
}
