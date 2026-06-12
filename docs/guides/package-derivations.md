# Package Derivations

In-repo package derivations live in `modules/derivations/`. This keeps them
separate from NixOS module config, making them reusable outside the system
configuration (e.g. with `nix build` or `nix shell`).

## How It Works

### Derivation file (`modules/derivations/<name>.nix`)

A standard Nix package derivation, callable with `pkgs.callPackage`:

```nix
{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.stdenv.mkDerivation {
  pname = "my-package";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://example.com/source.tar.gz";
    hash = "sha256-...";
  };
}
```

### NixOS module (`modules/pkgs/<name>.nix`)

A companion NixOS module that calls the derivation and adds it to the system:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.callPackage ../derivations/<name>.nix { })
  ];
}
```

### Registration in `modules/default.nix`

Both the program module and (if needed) the derivation are registered:

```nix
imports = [
  ./pkgs/<name>.nix
];
```

(The derivation itself doesn't need an import - it's pulled in by
`pkgs.callPackage` from the program module.)

## Example: Thorium Browser

**Derivation** (`modules/derivations/thorium.nix`):

```nix
{ pkgs ? import <nixpkgs> { } }:

let
  mkThorium = { pname, version, url, variant, hash }: ...;
in
{
  thorium-avx2 = mkThorium { ... };
  thorium-sse4 = mkThorium { ... };
}
```

**Program module** (`modules/pkgs/thorium.nix`):

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.callPackage ../derivations/thorium.nix { }).thorium-avx2
  ];
}
```

## Adding a New Derivation

1. Create the derivation in `modules/derivations/<name>.nix`
2. Create a NixOS module in `modules/pkgs/<category>.nix` that calls `pkgs.callPackage` on it
3. Add the category module to `modules/pkgs/default.nix` imports (or merge into an existing category file)

## Using Derivations Outside the System

Since derivations are standard callPackage functions, you can build them
directly:

```bash
nix build '.#nixosConfigurations.lament.pkgs.callPackage ./modules/derivations/thorium.nix { }'
```

Or import the flake from another project:

```nix
{
  inputs.my-config.url = "github:user/nixos-config";

  # Use a derivation
  packages.thorium = my-config.modules.derivations.thorium;
}
```
