# Adding a New Host

This guide walks through adding a new machine configuration to this flake.

## Overview

The machine-overlay pattern means every new host gets its own directory under
`hosts/`. Generic modules in `modules/` are shared across hosts and should not
need modification.

## Steps

### 1. Generate hardware config

On the target machine, run:

```bash
nixos-generate-config --show-hardware-config > hardware.nix
```

Copy this file into `hosts/<hostname>/hardware.nix`.

### 2. Create the host directory

```
hosts/<hostname>/
├── default.nix          # imports all host-specific files
├── hardware.nix         # from step 1
├── luks.nix             # (if needed) LUKS device paths
└── filesystems.nix      # (if needed) extra mount points
```

### 3. Create host-specific override files

**hosts/<hostname>/luks.nix** (if using LUKS):

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/<your-uuid>";
}
```

**hosts/<hostname>/filesystems.nix** (if using extra mounts):

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/<your-uuid>";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
```

### 4. Create the host default.nix

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./luks.nix
    ./filesystems.nix
  ];
}
```

### 5. Register the host in flake.nix

Add a new `nixosConfigurations` entry:

```nix
nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [
    ./configuration.nix
  ];
};
```

### 6. Rebuild

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Customising Modules per Host

Override any generic module option in `hosts/<hostname>/` using `lib.mkForce`:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.hostName = lib.mkForce "my-host";
}
```

## Selecting Features

By default, all modules in `modules/default.nix` are enabled. To disable
features for a specific host, use `lib.mkForce false`:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flatpak.enable = lib.mkForce false;
}
```
