{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager.cosmic-greeter.enable = lib.mkDefault true;
}
