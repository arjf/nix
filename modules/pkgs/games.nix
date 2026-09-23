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

    package = pkgs.steam.override {
      extraPkgs = pkgs': with pkgs'; [
        libXcursor
        libXi
        libXinerama
        libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib # Provides libstdc++.so.6
        libkrb5
        keyutils
        gamescope
      ];
    };
  };

  boot.kernelModules = [ "ntsync" ]; # for proton

  programs.gamescope = {
      enable = true;
      capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    # Stores
    heroic
    lutris

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
