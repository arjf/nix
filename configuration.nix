# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.nur.modules.nixos.default
  ];

  # Boot

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "split_lock_detect=off"
    # "split_lock_detect=warn"
    # "pcie_aspm=off"

    # Xe module for iGPU
    # "xe.force_probe=9a68"
    # "xe.enable_psr=0"
    # "xe.enable_fbc=0"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"

    # i915 module for iGPU
    "i915.force_probe=9a68"
    "i915.enable_psr=0"
    "i915.enable_guc=3"
    "i915.reset=3"
    "i915.enable_fbc=1"
    "intel_iommu=igfx_off"

    "panic=10"
    "oops=panic"
  ];

  # Emulated architectures
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  # Sysctl
  boot.kernel.sysctl = {
    # "vm.swappiness" = 60;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 134217728;
    "kernel.split_lock_mitigate" = 0;
    "vm.transparent_hugepage" = "madvise";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_7_0;
  boot.kernelModules = [
    "nvidia"
    # "nvidiafb"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "i915"
    "msi-ec"
    "acpi_ec"
    "ec_sys"
    "v4l2loopback"
    "snd-aloop"
  ];

  boot.extraModprobeConfig = ''
    options nvidia_drm fbdev=1
    options acpi_ec write_support=1
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1 report_ignored_msrs=0
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];

  boot.blacklistedKernelModules = [ "xe" ];

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/41f6c891-cf99-4d0f-9ff8-7438dcaba239";
  boot.supportedFilesystems = [ "ntfs" ];

  # This is a hacky way of running a newer version of msi-ec which supports my fw
  # Adapting the patches from the nixos-pkg
  boot.extraModulePackages = [
    (config.boot.kernelPackages.msi-ec.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "BeardOverflow";
        repo = "msi-ec";
        rev = "ffb36db8ae28a520dd570f56735de49845106e0e";
        sha256 = "sha256-MdFue0buh/8yE4lIdEbLa11pkwfRFvQ6VIU9mZM3hDo=";
      };
      patches = [ ];
      postPatch = ''
        # Replace the hardcoded paths
        # Append the modules_install target - required by Nixpkgs
        sed -i 's|/lib/modules/[^/]*/build|$(KERNELDIR)|g' Makefile
        echo -e '\nmodules_install:\n\t$(MAKE) -C $(KERNELDIR) M=$(CURDIR) modules_install' >> Makefile
      '';
    }))
    config.boot.kernelPackages.v4l2loopback
  ];

  # FS
  #
  fileSystems."/mnt/winstor" = {
    device = "/dev/disk/by-uuid/35DAEB472596A2F6";
    fsType = "ntfs3";
    options = [
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
      "uid=1000"
    ];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/5CDAC3B2DAC3872C";
    fsType = "ntfs3";
    options = [
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
      "uid=1000"
    ];
  };

  # Mount points for external HDD
  # still regret choosing exfat to this day
  # fileSystems."/mnt/arnav" = {
  #   device = "/dev/disk/by-uuid/DE82-04C5";
  #   fsType = "exfat";
  #   options = [
  #     "x-systemd.automount"
  #     "uid=1000"
  #     "nofail"
  #     "users"
  #     "fmask=0022"
  #     "dmask=0022"
  #     "exec"
  #     "rw"
  #   ];
  # };

  fileSystems."/mnt/w" = {
    device = "/dev/disk/by-uuid/5C12D51312D4F2CE";
    fsType = "ntfs3";
    options = [
      # "x-systemd.automount"
      "uid=1000"
      "nofail"
      "users"
      "force"
      "fmask=0022"
      "dmask=0022"
      "exec"
      "rw"
    ];
  };

  # fileSystems."/home/jo/w" = {
  #   device = "/mnt/w";
  #   fsType = "none";
  #   #depends = [ "/mnt/w" ];
  #   options = [
  #     "bind"
  #     "nofail"
  #     "x-systemd.automount"
  #     "x-systemd.requiresMountsFor=/mnt/w"
  #   ];
  # };

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";
  services.btrfs.autoScrub.fileSystems = [ "/" ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  #services.beesd.filesystems = {
  #  root = {
  #    spec = "";
  #    hashTableSizeMB = 2048;
  #    verbosity = "crit";
  #    extraOptions = [ "--loadavg-target" "5.0" ];
  #  };
  #};

  # Networking

  networking.hostName = "lament"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # TZ & Locales

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";`
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # DE & WM

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    # "modesetting"
    "nvidia"
  ];

  # Enable KDE Plasma
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Services

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # Depracated for wireplumber but idk if i need it
    #media-session.enable = true;
  };

  # Cuda package cache lists & keys
  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };
  nix.settings.auto-optimise-store = true;

  # Hardware
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.uinput.enable = true;
  hardware.xone.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      sync.enable = false;
      offload.enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      offload.enableOffloadCmd = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jo = {
    isNormalUser = true;
    description = "jo";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "libvirtd"
      "storage"
      "podman"
      "uinput"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      kdePackages.kate
    ];
    subGidRanges = [
      {
        count = 65536;
        startGid = 1000;
      }
    ];
    subUidRanges = [
      {
        count = 65536;
        startUid = 1000;
      }
    ];
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.jo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.stateVersion = "26.05";

      imports = [
        ./modules/zsh.nix
      ];
    };

  # Packages & Apps

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  # Caused too much recompilation.
  # Ideally I enable cudaSupport per package
  # nixpkgs.config.cudaSupport = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

  # pkgs installed in system profile.
  # https://search.nixos.org
  environment.systemPackages = with pkgs; [
    # cmdline
    neovim
    wget
    curl
    btop
    bat
    nethogs
    iotop
    net-tools
    binutils
    util-linux
    unzip
    screen
    tmux
    rsync
    coreutils
    lshw
    pciutils
    nvtopPackages.full
    ncdu
    usbutils
    fzf
    parted
    asdf-vm
    ripgrep
    atuin
    nmap

    # Nvim deps
    lazygit
    gdu
    bottom
    gdu

    # System
    btrfs-progs
    cryptsetup
    lvm2
    dosfstools
    throttled
    mcontrolcenter
    sof-firmware
    pavucontrol
    wl-clipboard

    # Shell
    zsh
    alacritty
    alacritty-theme
    kitty

    # Sec
    gnupg
    bitwarden-desktop
    bitwarden-cli
    keepassxc
    keybase-gui
    keybase

    # Cuda
    cudaPackages.cudnn
    cudaPackages.cudatoolkit

    # Dev
    docker
    zed-editor
    git
    gh
    github-desktop
    vscode
    javaPackages.compiler.temurin-bin.jdk-25
    autoconf
    qtscrcpy
    scrcpy
    comma
    distrobox
    nodejs_latest
    antigravity-fhs
    gemini-cli-bin
    claude-code
    codex

    # Nix
    nixd
    nil

    # Python
    micromamba
    pixi

    # C/C adjacent
    gcc
    gdb
    cmake
    pkg-config
    gnumake

    # General libs
    openssl
    openssl.dev
    zlib
    zlib.dev

    # Crustacean
    rustup # the lazy won
    # cargo
    # rustc
    # rustfmt
    # clippy
    # rust-analyzer

    # Go
    go
    gotools # utils, code fmt and IDE int
    gopls # golang server
    # go-tools # static-analysis and lint # included in golanci-lint
    golangci-lint # paralel lint
    # golangci-lint-langserver # redundant now
    delve # debugger

    # Games
    heroic-unwrapped
    lutris-unwrapped
    protonplus
    protonup-qt
    protonup-rs
    protontricks
    (prismlauncher.override {
      jdks = [
        jdk8
        jdk17
        jdk21
        jdk25
      ];
    })
    mangohud

    # Music & Media
    cider-2
    spotify
    jellyfin-desktop

    # libvirt/qemu
    virtiofsd
    virtio-win
    virt-viewer
    virt-manager
    qemu
    waydroid-helper
    pkgs.android-tools
    skopeo
    guestfs-tools
    virtiofsd
    moonlight-qt
    parsec-bin
    looking-glass-client

    # Misc
    tailscale
    deskflow
    vesktop
    obsidian
    droidcam
    remmina
    kdePackages.krdc
    v4l-utils
    materialgram
    (inputs.zen-browser.packages."${pkgs.system}".beta.override {
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };
    })
    (pkgs.callPackage ./modules/thorium.nix { }).thorium-avx2
    inputs.helium.packages.${system}.default
    wpsoffice
    onlyoffice-desktopeditors
    libreoffice-qt
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  # Virtualisation

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  # VMs with libvirt
  # systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      # ovmf = {
      #   enable = true;
      #   packages = [ pkgs.OVMFFull.fd ];
      # };
    };
  };
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 jo qemu-libvirtd -"
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Waydroid
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  systemd.packages = [ pkgs.waydroid-helper ];
  systemd.services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  services.geoclue2.enable = true;

  programs.kdeconnect = {
    enable = true;
  };

  # Services

  services.flatpak.enable = true;
  services.tailscale.enable = true;

  # Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Throttled daemon for managing intel CPUs
  services.throttled.enable = true;
  services.throttled.extraConfig = builtins.readFile ./etc/throttled.conf;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = true;
    };
    hardware.nvidia-container-toolkit.enable = lib.mkForce false;
    #users.users.jo.initialPassword = "test";
    users.users.jo.password = "test";
    users.mutableUsers = false;
  };

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
