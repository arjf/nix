{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # HM config for niri goes here.
  # The NixOS module (desktop/niri.nix) auto-imports homeModules.niri,
  # so we don't import it again here to avoid double-declaration.

  programs.niri.settings.binds = {
    "Mod+Print".action.screenshot-screen = {
      show-pointer = false;
    };
    "Mod+F4".action.quit.skip-confirmation = true;
    "Mod+D".action.spawn = "rofi -show drun";
  };

  programs.niri.settings.environment = { };
  programs.niri.settings.window-rules = [ ];
  programs.niri.settings.spawn-at-startup = [ { argv = [ "waybar" ]; } ]; # ,{ bash = [ "" ];}
  programs.niri.settings.input.focus-follows-mouse.enable = false;
  programs.niri.settings.input.mouse.accel-profile = null;

}
