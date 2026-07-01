{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Gen AI tools
  environment.systemPackages = with pkgs; [
    gemini-cli-bin
    claude-code
    codex
    opencode
    opencode-desktop
    windsurf
    devin-cli
    cursor-cli
    code-cursor-fhs
    antigravity-fhs
  ];
}
