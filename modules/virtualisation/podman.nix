{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.podman = {
    enable = lib.mkDefault true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.users.jo = {
    extraGroups = [ "podman" ];
    subGidRanges = [
      {
        count = 65536;
        startGid = 1000;
      }
    ];
    subUidRanges = [
      {
        count = 65536;
        startUid = 1000;
      }
    ];
  };
}
