{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

# DMS (Dank Material Shell) configuration, pinned in Nix.
#
# DMS keeps two JSON files: settings.json (appearance and behavior) and
# session.json (wallpaper, weather, light/dark and other per-session state).
# Both are written here, so home-manager symlinks them into the Nix store and
# DMS finds them read-only. That is a supported mode: DMS detects it, keeps
# running, and its settings window shows a "Settings are read-only" banner with
# "copy settings.json" / "copy session.json" buttons. The workflow is therefore
#
#   tweak live in the DMS settings window -> press the copy button -> paste the
#   value you wanted into the attribute sets below -> `make switch`
#
# Only keys that differ from DMS's own defaults are listed. DMS fills in the
# rest from its spec (quickshell/dms/Common/settings/{Settings,Session}Spec.js),
# so this file stays a diff against upstream instead of a 400-line dump.
let
  tawny = import ../lib/tawny.nix {
    inherit lib;
    tawnyNvim = inputs.tawnyNvim;
  };

  # The directory, not a single file: DMS cycles by listing the directory the
  # current wallpaper sits in (Services/WallpaperCyclingService.qml), so all of
  # them have to land next to each other in one store path. They are picked in
  # sorted order, which is what the numeric prefixes fix.
  wallpapers = ../../assets/wallpapers;
  firstWallpaper = "${wallpapers}/01-bamboo-gate.jpg";

  # Set to false to let DMS persist its own session.json again (brightness per
  # device, do-not-disturb, pinned apps, tray order, light/dark toggle). The
  # file is state as much as config, so freezing it also freezes those.
  lockSessionState = true;

  # tawny.nvim -> DMS's Material color roles. Both modes are provided; DMS picks
  # one by session.isLightMode.
  mkDmsColors = t: {
    # DMS reads the name off the per-mode object it picks, not the wrapper.
    name = "Tawny";
    primary = t.accent;
    primaryText = t.accentText;
    primaryContainer = t.accentContainer;
    secondary = t.secondary;
    surface = t.background;
    surfaceText = t.foreground;
    surfaceVariant = t.surfaceVariant;
    surfaceVariantText = t.surfaceVariantText;
    surfaceTint = t.accent;
    background = t.background;
    backgroundText = t.foreground;
    outline = t.outline;
    outlineVariant = t.outlineVariant;
    surfaceContainer = t.surfaceContainer;
    surfaceContainerHigh = t.surfaceContainerHigh;
    surfaceContainerHighest = t.surfaceContainerHighest;
    inherit (t)
      error
      warning
      info
      success
      ;
  };

  themeFile = "${config.xdg.configHome}/DankMaterialShell/tawny.json";

  # Pretty-printed, so the files stay readable next to what the DMS settings
  # window hands back through its copy buttons.
  toJson = name: value: (pkgs.formats.json { }).generate name value;
in
{
  # Custom theme consumed via settings.customThemeFile below.
  xdg.configFile."DankMaterialShell/tawny.json".source = toJson "dms-tawny.json" {
    name = "Tawny";
    dark = mkDmsColors tawny.tawnyThemes.dark;
    light = mkDmsColors tawny.tawnyThemes.light;
  };

  # force: DMS rewrites these on every change; Nix stays the source of truth.
  xdg.configFile."DankMaterialShell/settings.json" = {
    force = true;
    source = toJson "dms-settings.json" {
      # Colors come from tawny, not from matugen on the wallpaper.
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = themeFile;

      # niri's own appearance is owned by config/niri/config.kdl, and the
      # terminals/GTK are themed from tawny by home-manager, so DMS must not
      # write theme fragments for them. `runDmsMatugenTemplates = false` covers
      # every target except hyprland/mangowc, which need the explicit flags.
      runDmsMatugenTemplates = false;
      runUserMatugenTemplates = false;
      matugenTemplateHyprland = false;
      matugenTemplateMangowc = false;

      # Same pairing as GTK/dconf in nix/modules/desktop.nix.
      fontFamily = "IBM Plex Sans JP";
      monoFontFamily = "PlemolJP35 Console NF";
      # Matches the niri window-rule geometry-corner-radius.
      cornerRadius = 12;

      # Frosted glass. niri implements ext-background-effect-v1, so the
      # compositor blurs what sits behind each registered region (`dms blur
      # check` reports "supported"). Only the widget pills and the popouts
      # register regions — the bar itself has transparency = 0 below, and DMS
      # skips a fully transparent bar. The surfaces have to be translucent for
      # any of it to show, hence the two transparency values.
      blurEnabled = true;
      blurForegroundLayers = true;
      popupTransparency = 0.6;
      # Hairline rim on the blurred popouts, matching widgetOutlineColor.
      blurBorderColor = "primary";
      blurBorderOpacity = 0.35;

      use24HourClock = true;
      # Weather location is fixed in session.weatherLocation below, so DMS does
      # not look the machine up over ip-api.com on every start.
      useAutoLocation = false;
      weatherEnabled = true;

      # Carried over from the settings DMS had written before this file existed.
      controlCenterShowMicPercent = true;
      osdPowerProfileEnabled = true;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          # 0 top, 1 bottom, 2 left, 3 right, 4-7 the same four centered
          # (SettingsData.Position in Common/SettingsData.qml).
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;

          # Floating look: no bar background at all, so what you see is each
          # widget's own rounded background over the wallpaper. DMS has no
          # per-section background, only per-widget ones (Modules/Plugins/
          # BasePill.qml), so the pills are per widget, not per group.
          # `noBackground` would remove those pills too — leave it off.
          transparency = 0;
          # Translucent enough for the blur behind each pill to read.
          widgetTransparency = 0.5;
          # Insets the row from the screen edge so the pills float.
          spacing = 6;
          # A hairline accent outline on each pill, to hold them together
          # against a busy wallpaper.
          widgetOutlineEnabled = true;
          widgetOutlineColor = "primary";
          widgetOutlineOpacity = 0.35;
          widgetOutlineThickness = 1;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          rightWidgets = [
            # Shows and switches the active xkb layout (JIS/US), the same state
            # Mod+Space toggles via niri-layout-toggle.
            "keyboard_layout_name"
            # Dankscale plugin (plugin.json id, enabled in plugin_settings.json
            # below, installed by programs.dms-shell.plugins in
            # nix/system/nixos.nix).
            "dankscale"
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];
        }
      ];

      # Matches SettingsData.settingsConfigVersion; keeps DMS from trying to
      # migrate (and rewrite) the file.
      configVersion = 5;
    };
  };

  # Plugin enable flags and per-plugin settings live in their own file. A plugin
  # is only loaded when its "enabled" key is true (PluginService.qml), so this
  # is what replaces ticking the box in Settings -> Plugins.
  xdg.configFile."DankMaterialShell/plugin_settings.json" = {
    force = true;
    source = toJson "dms-plugin-settings.json" {
      dankscale.enabled = true;
    };
  };

  xdg.stateFile."DankMaterialShell/session.json" = lib.mkIf lockSessionState {
    force = true;
    source = toJson "dms-session.json" {
      isLightMode = false;
      # DMS draws the wallpaper itself on its background layer, which
      # config/niri/config.kdl puts inside the overview backdrop.
      wallpaperPath = firstWallpaper;
      # Rotates through the rest of assets/wallpapers every 30 minutes, with
      # DMS's default fade transition. session.json being read-only here, the
      # switch only lives in DMS's memory: every session starts again at
      # wallpaperPath above. `dms ipc call wallpaper next` (and prev) steps
      # through them by hand.
      wallpaperCyclingEnabled = true;
      wallpaperCyclingMode = "interval";
      wallpaperCyclingInterval = 1800;
      # 長野市. Resolved through open-meteo's geocoder, which answers
      # name "Nagano", 36.65/138.18333 — that name is what the bar shows.
      #
      # weatherCoordinates stays empty on purpose: it takes priority over the
      # name, and that path reverse-geocodes through Nominatim, whose reply for
      # central Nagano carries an address.hamlet. DMS prefers hamlet over city
      # (Services/WeatherService.qml), so the widget would read
      # "Kamichitosemachi" instead of "Nagano".
      weatherLocation = "Nagano";
      weatherCoordinates = "";
      configVersion = 3;
    };
  };
}
