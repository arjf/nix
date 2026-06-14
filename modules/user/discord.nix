{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;

    discord = {
      vencord.enable = false; # mutually exclusive with equicord
      equicord.enable = true;
      krisp.enable = true;
    };

    legcord = {
      enable = true;
      equicord.enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
        channel = "stable";
        tray = "dynamic";
        minimizeToTray = true;
        mods = [ "equicord" ];
        doneSetup = true;
      };
    };

    config = {
      autoUpdate = true;
      frameless = true;
      plugins = {
        clearUrls.enable = true; # Strips tracking params from shared URLs
        fixImagesQuality.enable = true; # Loads images at native resolution
        gameActivityToggle.enable = true; # Toggle game activity button
        crashHandler.enable = true; # Recovers from crashes without restart
        messageLatency.enable = true; # Shows ⚠ indicator on slow-to-send messages
        gifPaste.enable = true; # Gif picker inserts link instead of instant-send
        noReplyMention.enable = true; # Disables reply pings by default
        # silentTyping.enable = true; # Vencord-only, not in Equicord
        # spotifyControls.enable = true; # Vencord-only, not in Equicord
        imageZoom.enable = true; # Scroll-wheel zoom on images
        betterFolders.enable = true; # Folder sidebar + folder management
        noDevtoolsWarning.enable = true; # Removes "HOLD UP" console banner

        # Bannable
        # fakeNitro.enable = true; # sends emojis/stickers without Nitro,
        messageLogger.enable = true; # logs deleted & edited messages server-side.
      };
    };
  };
}
