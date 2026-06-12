{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kdeconnect.enable = lib.mkDefault true;
}
