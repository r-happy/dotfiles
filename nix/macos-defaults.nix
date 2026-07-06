{ ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      _HIHideMenuBar = false;
      "com.apple.sound.beep.volume" = 1.0;
      "com.apple.springing.delay" = 0.5;
      "com.apple.springing.enabled" = true;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.forceClick" = true;
      "com.apple.trackpad.scaling" = 3.0;
    };

    dock = {
      autohide = false;
      expose-group-apps = false;
      magnification = true;
      minimize-to-application = false;
      mru-spaces = false;
      orientation = "right";
      show-recents = false;
      showAppExposeGestureEnabled = false;
      showMissionControlGestureEnabled = true;
      tilesize = 32;
      wvous-br-corner = 14;
    };

    finder = {
      CreateDesktop = true;
      FXPreferredViewStyle = "Nlsv";
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
    };

    screencapture = {
      location = "~/Pictures/ScreenShots";
      target = "file";
      type = "png";
    };

    trackpad = {
      ActuateDetents = true;
      Clicking = true;
      DragLock = false;
      Dragging = false;
      FirstClickThreshold = 0;
      ForceSuppressed = false;
      SecondClickThreshold = 0;
      TrackpadCornerSecondaryClick = 0;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadMomentumScroll = true;
      TrackpadPinch = true;
      TrackpadRightClick = true;
      TrackpadRotate = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerHorizSwipeGesture = 0;
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 0;
      TrackpadTwoFingerDoubleTapGesture = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = [
          "en-JP"
          "ja-JP"
        ];
        AppleLocale = "en_JP";
        AppleMenuBarVisibleInFullscreen = true;
        AppleMiniaturizeOnDoubleClick = false;
        "com.apple.mouse.scaling" = 3.0;
        "com.apple.sound.beep.flash" = false;
        "com.apple.sound.uiaudio.enabled" = true;
      };

      "com.apple.finder" = {
        FXArrangeGroupViewBy = "Name";
        FXICloudDriveDesktop = false;
        FXICloudDriveDocuments = false;
        FXPreferredGroupBy = "Kind";
        NewWindowTarget = "PfAF";
      };

      "com.apple.screencapture" = {
        style = "window";
        video = false;
      };

      "com.apple.loginwindow" = {
        TALLogoutSavesState = false;
      };
    };
  };
}
