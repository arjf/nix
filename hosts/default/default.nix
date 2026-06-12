{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  system.host = hostname;
}
