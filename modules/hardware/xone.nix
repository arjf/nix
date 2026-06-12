{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.xone.enable = lib.mkDefault true;
}
