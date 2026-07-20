{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  imports = [
    ../../modules/desktop/default.nix
  ];

  system.host = hostname;
}
