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
    services.gnome.gnome-keyring.enable = false; # rely on kdewallet for now instead

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

    # kwalletd6 — primary keyring daemon (auto-unlocked by pam_kwallet5.so via ly)
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
      hypridle
      hyprpolkitagent
      hyprlang
      hyprshot
      hyprcursor
      hyprland-qt-support
      uwsm
      mate-polkit

      swaynotificationcenter

      wallust
      waypaper

      nwg-displays
      nwg-look
      thunar
      xfconf
      wdisplays
      wlr-randr
      wlogout

      grimblast
      grim
      slurp
      swappy

      awww
      hyprshutdown
      xdg-user-dirs
      playerctl
      pamixer
      yad
      xdg-utils
      gtk-engine-murrine

      cliphist
      brightnessctl
      libnotify
      socat

      jq
      cava

      nerd-fonts.jetbrains-mono

      blueman
      caffeine-ng
      networkmanagerapplet
    ];
  };
}
