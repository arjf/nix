{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.enable = lib.mkDefault true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;[
      xdg-desktop-portal-gtk
    ];
    config.common.default = lib.mkDefault "*";
  };
}
