{
  config,
  lib,
  pkgs,
  ...
}:
{
  time.timeZone = lib.mkDefault "Asia/Kolkata";

  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    # "en_IN.UTF-8/UTF-8"
  ];

  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    # "en_IN.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = lib.mkDefault {
    # LC_ALL = "en_US.UTF8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
  };
}
