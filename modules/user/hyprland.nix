{ config, lib, pkgs, inputs, my ? {}, ... }:

let
  cfg = my.hyprland.deployDots or false;
in
lib.mkIf cfg {
  programs.waybar.enable = lib.mkForce false;
  programs.rofi.enable = lib.mkForce false;
  services.mako.enable = lib.mkForce false;
}
