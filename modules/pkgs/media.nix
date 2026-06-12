{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Media
  environment.systemPackages = with pkgs; [
    # Playback
    cider-2
    spotify
    jellyfin-desktop
  ];
}
