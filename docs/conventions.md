# Conventions

## Module Structure

Every module follows the standard NixOS module function signature:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # module body
}
```

Modules that need flake inputs use the `inputs` special arg (passed via
`specialArgs` in `flake.nix`).

## Naming

| Element | Convention | Example |
|---|---|---|
| Files | `kebab-case.nix` | `obs-studio.nix`, `nix-ld.nix` |
| Subdirectories | `kebab-case` | `virtualisation/`, `hardware/` |
| Host directories | Hostname | `lament/` |

## File Size

If a module file exceeds ~100 lines, consider splitting it into smaller files
within a subdirectory (e.g. `boot/` → `default.nix`, `params.nix`, `sysctl.nix`).

## Overlap

Duplication across modules is acceptable when it serves independence. If two
modules both need to set a related option, each file should contain its own
config. This lets you enable/disable features by import without breaking
dependencies.

Example: `virt.nix` and `nvidia.nix` may both touch GPU-related settings.

## Overrides

Use `lib.mkForce`, `lib.mkDefault`, and `lib.mkIf` judiciously:

- **`lib.mkDefault`** - in generic `modules/` to allow host overrides
- **`lib.mkForce`** - in `hosts/<name>/` to pin machine-specific values
- **`lib.mkIf`** - when a module should only activate conditionally

## Commit Messages

Follow the existing pattern:

```
<action>:(<scope>) <message>
```

Examples from history:
```
add:(pkgs) thorium browser
fix:(boot) switch from xe to i915
chore:(fmt) reformat configuration.nix
add:(srv) sunshine, throttled
```

Common actions: `add`, `fix`, `chore`, `style`, `refactor`

## Imports

- **`modules/default.nix`** - the single registry for all generic module imports
- **`hosts/<name>/default.nix`** - the single registry for all host-specific imports
- **`configuration.nix`** - imports only the host overlay, home-manager, NUR, and
  `modules/default.nix`

## Disabling a Module

To disable a feature, comment out or remove its import line in
`modules/default.nix`. No other file needs to change.

## Adding a New Machine

1. Create `hosts/<new-hostname>/` directory
2. Create `hardware.nix` (run `nixos-generate-config` on the target machine)
3. Create `filesystems.nix` (and `luks.nix` if needed)
4. Create `hosts/<new-hostname>/default.nix` importing the above + opt-in modules
5. Add the new host to `flake.nix` outputs using `mkHost "<new-hostname>"`

No generic module should need modification.
