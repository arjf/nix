{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.enable = lib.mkDefault true;
}
