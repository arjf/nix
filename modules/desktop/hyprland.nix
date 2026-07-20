{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hw-accel.nix
    ./wayland-tooling.nix
  ];

  options.my.hyprland.deployDots = lib.mkEnableOption "deploy Hyprland-Dots dotfiles via Home Manager";

  config = {
    my.hyprland.deployDots = lib.mkDefault true;

    programs.hyprland = {
      enable = true;
      withUWSM = false;
      xwayland.enable = true;
    };

    programs.hyprlock.enable = true;
    programs.dconf.enable = true;

    services.printing.enable = lib.mkDefault true;
    services.gvfs.enable = lib.mkDefault true;
    services.udisks2.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = false;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };

    services.displayManager.defaultSession = lib.mkDefault "hyprland";

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      GTK_THEME = "Flat-Remix-GTK-Blue-Dark";
      DESKTOP_SESSION = "hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
    };

    systemd.user.services.mako.enable = lib.mkForce false;

    systemd.user.services.polkit-agent.enable = true;

    systemd.user.services.kwalletd = {
      description = "KDE Wallet Manager (kwalletd6)";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    environment.systemPackages = with pkgs; [
      # System-level Hyprland infrastructure
      hyprpolkitagent
      uwsm
      mate-polkit
      thunar
      xfconf
      xdg-user-dirs

      # System utilities
      networkmanagerapplet
      blueman
      libnotify
      socat
      jq
      brightnessctl
    ];
  };
}
