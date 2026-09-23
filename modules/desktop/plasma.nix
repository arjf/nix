{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.desktopManager.plasma6.enable = lib.mkDefault true;
}
