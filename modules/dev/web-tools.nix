{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Web development/testing tools
  environment.systemPackages = with pkgs; [
    playwright
    playwright-driver.browsers
    chromium
  ];

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
