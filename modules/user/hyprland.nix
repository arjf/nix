{
  config,
  lib,
  pkgs,
  inputs,
  my ? { },
  ...
}:

let
  cfg = my.hyprland.deployDots or false;
in
{
  home.packages = with pkgs; [
    # User-facing Hyprland tools
    hypridle
    hyprlang
    hyprshot
    hyprcursor
    hyprland-qt-support
    hyprshutdown
    awww

    # Notifications & OSD
    swaynotificationcenter

    # Theming
    wallust
    waypaper
    gtk-engine-murrine

    # Display management
    nwg-displays
    nwg-look
    wdisplays
    wlr-randr

    # Screenshot & recording
    grimblast
    grim
    slurp
    swappy
    cliphist

    # Media
    playerctl
    pamixer
    cava

    # Utilities
    yad
    xdg-utils

    # Fonts
    nerd-fonts.jetbrains-mono

    # Desktop apps
    caffeine-ng

    # Session management
    wlogout
  ];

  # Disable services that Hyprland-Dots provides its own config for
  programs.waybar.enable = lib.mkIf cfg (lib.mkForce false);
  programs.rofi.enable = lib.mkIf cfg (lib.mkForce false);
  # services.mako.enable = lib.mkIf cfg (lib.mkForce false);
}
