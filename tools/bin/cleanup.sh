#!/usr/bin/env bash
set -euxo pipefail

echo "Cleaning NixOS generations..."
sudo nix-collect-garbage -d
sudo nix-store --gc

echo "Cleaning nix profile history..."
nix profile wipe-history 2>/dev/null || true

echo "Cleaning nix-env generations..."
nix-env --delete-generations old 2>/dev/null || true

echo "Cleaning nix cache..."
rm -rf ~/.cache/nix/

echo "Done!"
