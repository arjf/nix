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
      vencord.enable = true;
      equicord.enable = false;
      openASAR.enable = true;
      krisp.enable = true;

      settings = {
        IS_MAXIMIZED = true;
        BACKGROUND_COLOR = "#000000";
        audioSubsystem = "experimental";
        offloadAdmControls = true;
        DESKTOP_TTI_REMOVE_V8_CACHE_CLEAR = true;
        DESKTOP_TTI_DNSTCP_WARMUP = true;
        DESKTOP_TTI_HTTP_CDT = true;
        DESKTOP_TTI_EARLY_UPDATE_CHECK = true;
        DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = false;
        openasar = {
          setup = true;
          quickstart = true;
          multiInstance = true;
        };
        asyncVideoInputDeviceInit = true;
      };
    };

    # legcord = {
    #   enable = false;
    #   vencord.enable = true;
    #   settings = {
    #     SKIP_HOST_UPDATE = true;
    #     channel = "stable";
    #     tray = "dynamic";
    #     minimizeToTray = true;
    #     mods = [ "vencord" ];
    #     doneSetup = true;
    #   };
    # };

    config = {
      autoUpdate = true;
      autoUpdateNotification = true;
      useQuickCss = true;
      frameless = false;
      transparent = true;
      disableMinSize = true;

      plugins = {
        #fakeNitro = {
        #  enable = false;
        #  emojiSize = "48";
        #  stickerSize = "160";
        #};
        alwaysAnimate.enable = true;
        alwaysExpandRoles.enable = true;
        alwaysTrust = {
          enable = true;
          domain = true;
          file = true;
        };
        anonymiseFileNames.enable = true;
        betterFolders = {
          enable = true;
          sidebar = true;
          showFolderIcon = 1;
          keepIcons = false;
          closeAllHomeButton = false;
          closeAllFolders = false;
          forceOpen = false;
          sidebarAnim = true;
        };
        betterGifAltText.enable = true;
        betterGifPicker.enable = true;
        betterRoleContext.enable = true;
        betterRoleDot = {
          enable = true;
          bothStyles = false;
          copyRoleColorInProfilePopout = false;
        };
        betterSessions = {
          enable = true;
          backgroundCheck = false;
        };
        betterSettings = {
          enable = true;
          disableFade = true;
          eagerLoad = true;
          organizeMenu = true;
        };
        betterUploadButton.enable = true;
        biggerStreamPreview.enable = true;
        callTimer.enable = true;
        characterCounter.enable = true;
        clearUrls.enable = true;
        copyStickerLinks.enable = true;
        copyUserUrls.enable = true;
        crashHandler.enable = true;
        customRpc.enable = true;
        fixImagesQuality = {
          enable = true;
          originalImagesInChat = false;
        };
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        forceOwnerCrown.enable = true;
        gameActivityToggle = {
          enable = true;
        };
        gifPaste.enable = true;
        iLoveSpam.enable = true;
        imageFilename = {
          enable = true;
          showFullUrl = false;
        };
        ircColors = {
          enable = true;
          memberListColors = true;
          lightness = 70;
          applyColorOnlyInDms = false;
          applyColorOnlyToUsersWithoutColor = false;
        };
        keepCurrentChannel.enable = true;
        messageLinkEmbeds.enable = true;
        moreQuickReactions = {
          enable = true;
          reactionCount = 5;
        };
        noOnboardingDelay.enable = true;
        noSystemBadge.enable = true;
        notificationVolume = {
          enable = true;
          notificationVolume = 100.0;
        };
        # cursorBuddy.enable = true;
        permissionsViewer.enable = true;
        petpet.enable = true;
        pictureInPicture.enable = true;
        platformIndicators = {
          enable = true;
          colorMobileIndicator = true;
          list = true;
          badges = true;
          messages = true;
        };
        previewMessage.enable = true;
        quickMention.enable = true;
        quickReply.enable = true;
        replyTimestamp.enable = true;
        revealAllSpoilers.enable = true;
        reverseImageSearch.enable = true;
        sendTimestamps.enable = true;
        serverInfo.enable = true;
        serverListIndicators = {
          enable = true;
          mode = 2;
        };
        showMeYourName = {
          enable = true;
          mode = "user-nick";
          friendNicknames = "dms";
          displayNames = false;
          inReplies = false;
        };
        sortFriendRequests = {
          enable = true;
          showDates = false;
        };
        spotifyControls = {
          enable = true;
          hoverControls = false;
        };
        translate = {
          enable = true;
          autoTranslate = false;
        };
        typingIndicator = {
          enable = true;
          includeMutedChannels = false;
          includeCurrentChannel = true;
        };
        typingTweaks = {
          enable = true;
          alternativeFormatting = true;
        };
        unindent.enable = true;
        unlockedAvatarZoom.enable = true;
        userMessagesPronouns = {
          enable = true;
          showSelf = true;
          pronounsFormat = "LOWERCASE";
        };
        userVoiceShow = {
          enable = true;
          showInUserProfileModal = true;
          showInMemberList = true;
          showInMessages = true;
        };
        validReply.enable = true;
        validUser.enable = true;
        voiceDownload.enable = true;
        voiceMessages.enable = true;
        volumeBooster.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
