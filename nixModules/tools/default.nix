{
  userConfig,
  pkgs,
  lib,
  config,
}: let
  inherit (userConfig) shell username editor terminal email colorscheme font;
  isDisabled = attribute: lib.hasAttr attribute userConfig && userConfig.tmux == false;
in {
  imports =
    [
      (import ./git/home.nix {inherit username email;})
      (import ./seto/default.nix {inherit colorscheme username font;})
      (import ./msmtp/default.nix {inherit config username email lib;})
    ]
    ++ (
      if terminal == "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if terminal == "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ (
      if editor == "nvim"
      then [(import ./nvim/default.nix {inherit pkgs username colorscheme;})]
      else []
    )
    ++ (
      if isDisabled "tmux"
      then []
      else [(import ./tmux/home.nix {inherit pkgs username shell colorscheme;})]
    )
    ++ (
      if isDisabled "nh"
      then []
      else [(import ./nh/default.nix {inherit username pkgs;})]
    )
    ++ (
      if isDisabled "zoxide"
      then []
      else [(import ./zoxide/default.nix {inherit username shell pkgs;})]
    );
}
