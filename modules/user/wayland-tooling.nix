let
  waybarCfg = builtins.fromJSON (builtins.readFile ./config/waybar.json);
in
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    settings = waybarCfg.settings;
    style = waybarCfg.style;
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };

  programs.rofi.enable = true;
}
