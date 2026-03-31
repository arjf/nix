# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "split_lock_mitigate=0" ];

  #
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "msi-ec" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/41f6c891-cf99-4d0f-9ff8-7438dcaba239";
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
  ];

  # FS

  fileSystems."/" = {
    #device = "/dev/disk/by-uuid/67965a9d-a137-4a9f-816b-5c1add1a69da"
    #fsType = "btrfs";
    options = [ "compress=zstd" ];
  };


  fileSystems."/home" = {
    #device = "/dev/disk/by-uuid/67965a9d-a137-4a9f-816b-5c1add1a69da"
    #fsType = "btrfs";
    options = [ "compress=zstd" ];
  };


  fileSystems."/nix" = {
    #device = "/dev/disk/by-uuid/67965a9d-a137-4a9f-816b-5c1add1a69da"
    #fsType = "btrfs";
    options = [ "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AA6A-89B3";
    fsType = "vfat";
  };

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
      "x-systemd.automount"
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

  swapDevices = [ {device = "/dev/disk/by-uuid/b1a3f251-18b2-4c03-ad42-775da7c7e5d2";} ];

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
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";`
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # DE & WM

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

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

  # Hardware
  hardware.bluetooth.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false; # Maybe open to in the future, once
    nvidiaSettings = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Create a OTG boot entry with GPU offload disabled
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
	prime.offload.enableOffloadCmd = lib.mkForce true;
	prime.sync.enable = lib.mkForce false;
      };
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jo = {
    isNormalUser = true;
    description = "jo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirtd" "storage" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      kdePackages.kate
    ];
  };

  # Packages & Apps

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  # Caused too much recompilation.
  # Ideally I enable cudaSupport per package
  # nixpkgs.config.cudaSupport = true;

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

    # Games
    heroic-unwrapped
    lutris-unwrapped
    protonplus
    protonup-qt
    protonup-rs
    protontricks
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 jdk25 ]; })
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

    # Misc
    tailscale
    deskflow
    vesktop
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
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
  virtualisation.libvirtd = {
   enable = true;
   qemu = {
     package = pkgs.qemu_kvm;
     runAsRoot = true;
     swtpm.enable = true;
   };
  };
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];

  # Waydroid
  virtualisation.waydroid.enable = true;
  systemd.packages = [ pkgs.waydroid-helper ];
  systemd.services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  services.geoclue2.enable = true;
  programs.adb.enable = true;

  programs.kdeconnect = {
    enable = true;
  };

  # Services

  services.tailscale.enable = true;

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

  services.openssh.enable = true;

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
