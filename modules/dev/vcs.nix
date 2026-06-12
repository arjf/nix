{
  config,
  lib,
  pkgs,
  ...
}: {
  # Version control (VCS)
  environment.systemPackages = with pkgs; [
    git
    gh
    github-desktop
  ];
}
