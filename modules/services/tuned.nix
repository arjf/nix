{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.tuned = {
    enable = lib.mkDefault true;
    ppdSupport = lib.mkDefault true;
  };
}
