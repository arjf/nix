{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionPath = [ "$HOME/.bun/bin" ];

  home.activation.installKilocodeCli = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.bun/bin/kilo" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.bun/bin"
      $DRY_RUN_CMD ${pkgs.bun}/bin/bun install -g @kilocode/cli
    fi
  '';
}
