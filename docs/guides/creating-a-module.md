# Creating a Module

This guide covers how to write a new NixOS module that fits into this
repository's structure.

## Module Template

Every module starts with the standard NixOS module function signature:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # options, config, or imports
}
```

If you need flake inputs, add `inputs` as a special arg (it's passed via
`specialArgs` in `flake.nix`):

```nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.zen-browser.packages."${pkgs.system}".beta
  ];
}
```

## Where to Put It

| Type | Location |
|---|---|
| Core system feature | `modules/core/<name>.nix` |
| Hardware capability | `modules/hardware/<name>.nix` |
| System service | `modules/services/<name>.nix` |
| Desktop / WM | `modules/desktop/<name>.nix` |
| Virtualisation | `modules/virtualisation/<name>.nix` |
| Program / package category | `modules/pkgs/<category>.nix` |
| Dev tooling | `modules/dev/<name>.nix` |
| User config (HM) | `modules/user/<name>.nix` |
| Package derivation | `modules/derivations/<name>.nix` |

## Registering the Module

Add the import path to `modules/default.nix`:

```nix
{
  imports = [
    # ... existing imports ...
    ./<category>/<name>.nix
  ];
}
```

## Module Guidelines

### Keep It Focused

Each module should cover one feature or concern. If a module grows past ~100
lines, split it into a subdirectory (e.g. `boot/default.nix`,
`boot/params.nix`).

### Allow Overrides

Use `lib.mkDefault` for values that hosts might want to override:

```nix
networking.hostName = lib.mkDefault "lament";
```

### Prefer Independence

If your module overlaps with another, keep the relevant config in both files
rather than creating a dependency. Users should be able to enable/disable
features by import without cascading changes.

### Use Conditionals

Use `lib.mkIf` for conditional config:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.my-service;
in
{
  options.services.my-service = {
    enable = lib.mkEnableOption "my service";
  };

  config = lib.mkIf cfg.enable {
    # config that only applies when enabled
  };
}
```

## Example: A Simple Service Module

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.example = {
    enable = true;
    settings = {
      option1 = "value";
      option2 = 42;
    };
  };
}
```
