{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.gamemode.enable = lib.mkDefault true;

  programs.steam = {
    enable = lib.mkDefault true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    # Stores
    heroic-unwrapped
    lutris-unwrapped

    # Wine tools
    protonplus
    protonup-qt
    protonup-rs
    protontricks

    # Minecraft
    (prismlauncher.override {
      jdks = [
        jdk8
        jdk17
        jdk21
        jdk25
      ];
    })

    # Tools
    mangohud
  ];
}
