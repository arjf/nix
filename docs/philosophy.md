# Philosophy

## Composability over Monoliths

Every concern lives in its own file. The old `configuration.nix` was a single
file. The new structure lets you find, change, or disable any feature by opening one
small file, or commenting out one import line.

## Pick and Choose

Files are designed to be independent. Overlapping config is fine, if both
`virt.nix` and `nvidia.nix` need to set GPU-related options, each file contains
what it needs. Enable or disable a feature by adding or removing its import in
`modules/default.nix`.

## Machine-Overlay Pattern

- **`modules/`** - generic, reusable capability declarations (e.g. "enable a
  Bluetooth stack", "configure PipeWire")
- **`hosts/<name>/`** - machine-specific bindings (disk UUIDs, device paths,
  `mkForce` overrides)

This keeps modules portable. Adding a new machine means creating a new host
directory - no generic module needs to change.

## Integral vs. Add-on

- **Integral** system capabilities (audio, boot, networking, locale) are grouped
  by subsystem in `core/` and `hardware/`.
- **External** or optional services (Tailscale, Sunshine, Flatpak) are standalone
  files in `services/`.

## Flat over Nested

Subdirectories for broad categories, limited to 3 levels at most. A file per
meaningful unit - if a module file needs more than ~100 lines, consider splitting
it (e.g. `boot/` became `default.nix`, `params.nix`, `sysctl.nix`).

## Derive Once, Install Anywhere

In-repo package derivations live in `modules/derivations/`. The corresponding
NixOS module in `modules/pkgs/` calls `pkgs.callPackage` to make the package
available. This keeps derivations independent of system config.
