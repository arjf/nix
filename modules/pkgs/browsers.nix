{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Firefox
  programs.firefox.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    (inputs.zen-browser.packages.${pkgs.system}.beta.override {
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };
    })
    inputs.helium.packages.${pkgs.system}.default
    (pkgs.callPackage ../derivations/thorium.nix { }).thorium-avx2
  ];
}
