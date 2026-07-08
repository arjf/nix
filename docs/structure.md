# Structure

```
.
├── flake.nix                          # Entry point - inputs, outputs, mkHost helper
├── flake.lock                         # Locked flake inputs
├── configuration.nix                  # Thin root: 3 imports + stateVersion default
├── .sops.yaml                         # SOPS encryption rules (PGP key + host age keys)
├── secrets.yaml                       # Encrypted SOPS secret store (root-level defaults)
├── secrets/                           # Per-context encrypted secrets (future)
│   └── .gitkeep
│
├── hosts/                             # Machine-specific config (one dir per host)
│   ├── default/                       # Minimal test profile (tmpfs root)
│   │   └── default.nix
│   ├── lament/                        # Intel/NVIDIA/MSI laptop
│   │   ├── default.nix                # Host overlay - imports + overrides
│   │   ├── hardware.nix               # Hardware scan output
│   │   ├── luks.nix                   # Real LUKS UUID (mkForce)
│   │   └── filesystems.nix            # LVM + NTFS mount points
│   └── nixy/                          # AMD desktop
│       ├── default.nix                # Host overlay - imports + overrides
│       ├── hardware.nix               # Hardware scan output (AMD CPU/GPU)
│       └── filesystems.nix            # Btrfs subvol layout
│
├── modules/
│   ├── default.nix                    # Registry - lists all category defaults
│   │
│   ├── core/                          # Foundational - always needed
│   │   ├── default.nix                # Aggregates siblings
│   │   ├── boot/
│   │   │   ├── default.nix            # Bootloader, kernel selection, binfmt
│   │   │   ├── params.nix             # Kernel parameters
│   │   │   └── sysctl.nix             # Kernel sysctl settings
│   │   ├── host.nix                   # system.host option, hostPlatform, tmpfs root
│   │   ├── networking.nix             # NetworkManager
│   │   ├── locale.nix                 # Timezone, language, locale settings
│   │   ├── users.nix                  # User accounts and groups
│   │   ├── nix.nix                    # Nix daemon settings (GC, features)
│   │   ├── shell.nix                  # my.pathAdditions option for cross-module PATH
│   │   ├── btrfs.nix                  # Btrfs auto-scrub (opt-in by hosts)
│   │   ├── lvm.nix                    # LVM initrd modules (opt-in by hosts)
│   │   ├── luks.nix                   # LUKS skeleton (opt-in, mkDefault UUID)
│   │   ├── secure-boot.nix            # Lanzaboote secure boot (host-opt-in)
│   │   ├── snapshots.nix              # Snapper btrfs snapshots + 30d auto-GC (host-opt-in)
│   │   └── vm-variant.nix             # Build VM overrides
│   │
│   ├── hardware/                      # Hardware capabilities
│   │   ├── default.nix                # Common: firmware, uinput, env vars
│   │   ├── audio.nix                  # PipeWire + rtkit
│   │   ├── bluetooth.nix              # Bluetooth stack
│   │   ├── graphics.nix               # Graphics acceleration
│   │   ├── wifi.nix                   # WiFi power management
│   │   ├── ec.nix                     # ACPI EC modules (acpi_ec, ec_sys)
│   │   ├── xone.nix                   # Xbox One controller driver
│   │   ├── msi.nix                    # MSI laptop EC (msi-ec kmod via overrideAttrs) - host-opt-in
│   │   ├── i915.nix                   # Intel i915 GPU params - host-opt-in
│   │   ├── nvidia.nix                 # NVIDIA GPU (modesetting, prime) - host-opt-in
│   │   └── v4l2lo.nix                 # v4l2loopback - pulled by obs-studio
│   │
│   ├── services/                      # Optional system services
│   │   ├── default.nix                # Aggregates siblings (printing, gvfs, udisks2)
│   │   ├── sops.nix                   # SOPS secret management (sops-nix import + secrets.yaml)
│   │   ├── tailscale.nix              # Tailscale VPN
│   │   ├── flatpak.nix                # Flatpak support
│   │   ├── cuda.nix                   # CUDA cache substituters
│   │   ├── kdeconnect.nix             # KDE Connect phone integration
│   │   ├── tuned.nix                  # tuneD power-profiles-daemon compat (host-opt-in)
│   │   ├── powertop.nix               # Powertop auto-tuning (host-opt-in)
│   │   └── throttled.nix              # Intel CPU throttling daemon (host-opt-in)
│   │
│   ├── desktop/                       # Display manager + DE (swappable)
│   │   ├── default.nix                # Aggregates siblings + wl-clipboard
│   │   ├── sddm.nix                   # SDDM display manager
│   │   └── plasma.nix                 # KDE Plasma 6 desktop (mkDefault video drivers)
│   │
│   ├── virtualisation/                # Pick and choose independently
│   │   ├── default.nix                # Aggregates siblings
│   │   ├── kvm.nix                    # KVM kernel module config
│   │   ├── docker.nix                 # Docker container runtime
│   │   ├── podman.nix                 # Podman container runtime
│   │   ├── virt.nix                   # libvirt + looking-glass
│   │   └── waydroid.nix               # Waydroid Android environment
│   │
│   ├── pkgs/                          # Category-based program modules
│   │   ├── default.nix                # Aggregates siblings + allowUnfree
│   │   ├── nix-ld.nix                 # Nix LD (dynamic linker for binaries)
│   │   ├── obs-studio.nix             # OBS Studio (pulls v4l2lo)
│   │   ├── zsh.nix                    # NixOS-level zsh enable
│   │   ├── cmdline-tools.nix          # CLI utilities (btop, ripgrep, fzf, lsd, fastfetch, etc.)
│   │   ├── term-emus.nix              # Terminal emulators (alacritty, kitty)
│   │   ├── security.nix               # Security tools (gnupg, keepassxc, etc.)
│   │   ├── games.nix                  # Gaming (steam, heroic, gamemode, prismlauncher)
│   │   ├── socials.nix                # Social/messaging (vesktop, materialgram)
│   │   ├── office.nix                 # Office apps (libreoffice, wpsoffice, obsidian)
│   │   ├── browsers.nix               # Browsers (firefox, zen, helium, thorium)
│   │   ├── media.nix                  # Media playback
│   │   └── rc.nix                     # Remote desktop (remmina, krdc, droidcam, moonlight)
│   │
│   ├── dev/                           # Development tooling
│   │   ├── default.nix                # Aggregates siblings + generic dev pkgs
│   │   ├── python.nix                 # Python (micromamba, pixi)
│   │   ├── go.nix                     # Go toolchain
│   │   ├── rust.nix                   # Rust toolchain (rustup)
│   │   ├── nix.nix                    # Nix language tooling (nixd, nil)
│   │   ├── c.nix                      # C/C++ toolchain (gcc, cmake, etc.)
│   │   ├── node.nix                   # Node.js + comma
│   │   ├── editors.nix                # Editors (neovim, vscode, zed)
│   │   ├── gen-tools.nix              # Gen-AI tools (claude-code, gemini-cli, opencode)
│   │   └── vcs.nix                    # Version control (git, gh)
│   │
│   ├── user/                          # Home-manager user config
│   │   ├── default.nix                # Aggregates home-manager modules
│   │   ├── home.nix                   # Home-manager wrapper + user entry
│   │   └── zsh.nix                    # ZSH user config (oh-my-zsh, plugins, aliases, fzf, fastfetch)
│   │
│   └── derivations/                   # In-repo package derivations
│       └── thorium.nix                # Thorium browser AppImage wrapper
│
├── overrides/                         # Sharable machine-specific overrides
│   └── bose-soundbar.nix              # Bose soundbar wireplumber config
│
├── tools/
│   └── bin/
│       └── update-derivations.sh       # Bump fetchFromGitHub rev/hash
│
├── docs/
│   ├── philosophy.md
│   ├── structure.md                   # This file
│   ├── conventions.md
│   └── guides/
│       ├── adding-a-host.md
│       ├── creating-a-module.md
│       └── package-derivations.md
│
├── AI.md
└── README.md
```

## Import Chain

```
flake.nix
  └── configuration.nix
        ├── home-manager.nixosModules.default
        ├── nur.modules.nixos.default
        └── modules/default.nix
              ├── core/default.nix
              │     ├── boot/default.nix
              │     │     ├── params.nix
              │     │     └── sysctl.nix
              │     ├── host.nix
              │     ├── networking.nix
              │     ├── locale.nix
              │     ├── users.nix
              │     ├── nix.nix
              │     ├── shell.nix
              │     └── vm-variant.nix
              ├── hardware/default.nix
              │     ├── audio.nix
              │     ├── bluetooth.nix
              │     ├── graphics.nix
              │     ├── wifi.nix
              │     ├── ec.nix
              │     └── xone.nix
              ├── services/default.nix
              │     ├── sops.nix
              │     ├── tailscale.nix
              │     ├── flatpak.nix
              │     ├── kdeconnect.nix
              │     └── ssh.nix
              ├── desktop/default.nix
              │     ├── sddm.nix
              │     └── plasma.nix
              ├── virtualisation/default.nix
              │     ├── kvm.nix
              │     ├── docker.nix
              │     ├── podman.nix
              │     ├── virt.nix
              │     └── waydroid.nix
              ├── pkgs/default.nix
              │     ├── nix-ld.nix
              │     ├── obs-studio.nix
              │     ├── zsh.nix
              │     ├── cmdline-tools.nix
              │     ├── term-emus.nix
              │     ├── security.nix
              │     ├── games.nix
              │     ├── socials.nix
              │     ├── office.nix
              │     ├── browsers.nix
              │     ├── media.nix
              │     └── rc.nix
              ├── dev/default.nix
              │     ├── python.nix
              │     ├── go.nix
              │     ├── rust.nix
              │     ├── nix.nix
              │     ├── c.nix
              │     ├── node.nix
              │     ├── editors.nix
              │     ├── gen-tools.nix
              │     └── vcs.nix
              ├── user/home.nix
              │     └── user/default.nix
              │           └── zsh.nix
              └── core/vm-variant.nix

  hosts/<name>/default.nix  (appended per-host via flake.nix mkHost)
    ├── hardware.nix
    ├── luks.nix           (lament only)
    ├── filesystems.nix
    ├── core/lvm.nix       (lament only)
    ├── core/luks.nix      (lament only)
    ├── core/btrfs.nix
    ├── core/secure-boot.nix
    ├── core/snapshots.nix
    ├── hardware/msi.nix   (lament only)
    ├── hardware/i915.nix  (lament only)
    ├── hardware/nvidia.nix (lament only)
    ├── services/cuda.nix  (lament only)
    ├── services/tuned.nix (nixy only)
    ├── services/powertop.nix (nixy only)
    ├── services/throttled.nix (lament only)
    └── overrides/bose-soundbar.nix  (lament only)
```
