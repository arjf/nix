{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.xserver.enable = lib.mkDefault true;

  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.videoDrivers = lib.mkDefault [
    "modesetting"
  ];
}
