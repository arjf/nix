{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Rust development
  environment.systemPackages = with pkgs; [
    rustup
  ];
}
