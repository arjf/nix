{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = lib.mkDefault true;

  users.users.jo.extraGroups = [ "networkmanager" ];
}
