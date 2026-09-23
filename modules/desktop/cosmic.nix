{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.desktopManager.cosmic.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
  };

  # environment.systemPackages = with pkgs; [
  #   # cosmic-ext-applet-workspace-icons

  # ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;[
      xdg-desktop-portal-cosmic
      xdg-desktop-portal-gtk
    ];
    config.common = {
      default = lib.mkForce [ "cosmic" "gtk"];
    };
  };
}
