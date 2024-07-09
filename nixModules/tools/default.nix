{
  userConfig,
  pkgs,
  lib,
  config,
  helpers,
  inputs,
}: let
  inherit (userConfig) username colorscheme font;
  shell = lib.mkDefault (
    if lib.hasAttr "shell" userConfig
    then userConfig.shell
    else "bash"
  );
in {
  imports =
    [
      (import ./git/home.nix {inherit username;})
    ]
    ++ (
      if lib.hasAttr "email" userConfig
      then [
        (import ./msmtp/default.nix {
          inherit config username lib;
          email = userConfig.email;
        })
      ]
      else []
    )
    ++ (
      if helpers.checkAttribute "terminal" "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if helpers.checkAttribute "terminal" "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ (
      if helpers.checkAttribute "editor" "nvim"
      then [(import ./nvim/default.nix {inherit pkgs username colorscheme inputs;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "tmux"
      then [(import ./tmux/home.nix {inherit pkgs username shell colorscheme;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "seto"
      then [(import ./seto/home.nix {inherit colorscheme username font pkgs inputs;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "nh"
      then [(import ./nh/default.nix {inherit username pkgs;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "zoxide"
      then [(import ./zoxide/default.nix {inherit username shell pkgs;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "man"
      then [(import ./man/default.nix {inherit pkgs;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "lsd"
      then [(import ./lsd/default.nix {inherit username;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "bat"
      then [(import ./bat/default.nix {inherit username;})]
      else []
    )
    ++ (
      if !helpers.isDisabled "direnv"
      then [(import ./direnv/default.nix {inherit username shell;})]
      else []
    );
}
