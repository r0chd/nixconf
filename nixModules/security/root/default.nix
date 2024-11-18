{ lib, ... }:
{
  imports = [
    ./sudo
    ./doas
  ];

  options.root = lib.mkOption {
    type = lib.types.enum [
      "sudo"
      "doas"
    ];
    default = "sudo";
  };

  config.security.sudo.enable = lib.mkDefault false;
}
