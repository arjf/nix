{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.btrfs.autoScrub.enable = lib.mkDefault true;
  services.btrfs.autoScrub.interval = lib.mkDefault "weekly";
  services.btrfs.autoScrub.fileSystems = lib.mkDefault [ "/" ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];
}
