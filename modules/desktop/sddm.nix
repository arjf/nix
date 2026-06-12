{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager.sddm.enable = lib.mkDefault true;
}
