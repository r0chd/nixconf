{
  userConfig,
  pkgs,
  lib,
  config,
  helpers,
  inputs,
}: let
  inherit (userConfig) username colorscheme font;
  inherit (helpers) checkAttribute isDisabled;
  inherit (lib) optional hasAttr;
  shell = lib.mkDefault (
    if hasAttr "shell" userConfig
    then userConfig.shell
    else "bash"
  );
in {
  imports =
    [
      (import ./git/home.nix {inherit username config;})
    ]
    ++ optional (hasAttr "email" userConfig)
    (import ./msmtp/default.nix {
      inherit config username lib;
      email = userConfig.email;
    })
    ++ (
      if checkAttribute "terminal" "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if checkAttribute "terminal" "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ optional (checkAttribute "editor" "nvim") (import ./nvim/default.nix {inherit pkgs username colorscheme inputs;})
    ++ optional (!isDisabled "tmux") (import ./tmux/home.nix {inherit pkgs username shell colorscheme;})
    ++ optional (!isDisabled "seto") (import ./seto/home.nix {inherit colorscheme username font pkgs inputs;})
    ++ optional (!isDisabled "nh") (import ./nh/default.nix {inherit username pkgs;})
    ++ optional (!isDisabled "zoxide") (import ./zoxide/default.nix {inherit username shell;})
    ++ optional (!isDisabled "man") (import ./man/default.nix {inherit pkgs;})
    ++ optional (!isDisabled "lsd") (import ./lsd/default.nix {inherit username;})
    ++ optional (!isDisabled "bat") (import ./bat/default.nix {inherit username;})
    ++ optional (!isDisabled "direnv") (import ./direnv/default.nix {inherit username shell;});
}
