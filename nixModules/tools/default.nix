{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (config) shell nh zoxide username editor terminal tmux email colorscheme font;
in {
  imports =
    [
      (import ./git/home.nix {inherit username email;})
      (import ./seto/default.nix {inherit colorscheme username font;})
    ]
    ++ (
      if terminal == "kitty"
      then [(import ./kitty/home.nix {inherit username font;})]
      else if terminal == "foot"
      then [(import ./foot/home.nix {inherit username font;})]
      else []
    )
    ++ (
      if tmux == true
      then [(import ./tmux/home.nix {inherit pkgs username shell colorscheme;})]
      else []
    )
    ++ (
      if nh == true
      then [(import ./nh/default.nix {inherit username pkgs;})]
      else []
    )
    ++ (
      if zoxide == true
      then [(import ./zoxide/default.nix {inherit username shell pkgs;})]
      else []
    )
    ++ (
      if editor == "nvim"
      then [(import ./nvim/default.nix {inherit pkgs inputs username colorscheme;})]
      else []
    );
}
