{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.waydroid.enable = lib.mkDefault true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  systemd.packages = [ pkgs.waydroid-helper ];
  systemd.services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  services.geoclue2.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    waydroid-helper
    pkgs.android-tools
  ];
}
