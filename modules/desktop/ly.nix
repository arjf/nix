{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = true;
      bg = "0x00000000";
      fg = "0x0000FFFF";
      border_fg = "0x00FF0000";
      error_fg = "0x00FF0000";
      clock_color = "#800080";
    };
  };
}
