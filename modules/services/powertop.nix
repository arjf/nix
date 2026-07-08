{
  config,
  lib,
  pkgs,
  ...
}:
{
  powerManagement.powertop.enable = lib.mkDefault true;
}
