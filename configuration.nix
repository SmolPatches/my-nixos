# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs, config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  nixpkgs.overlays = [
    # use ungoogled chromium
    (final: prev: { chromium = prev.ungoogled-chromium.override { enableWideVine = true; }; })
  ];
  # secrets
  # wip
  age.secrets = {
    # secret nix code that you don't want anyone to see
    nix-code = {
      file = /home/watashi/my-nixos/secrets/nix-code.age;
      owner = "watashi";
      mode = "600";
    };
  };
  #enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./conf/nvidia.nix
      /run/agenix/nix-code # run code from agenix that is encrypted
      # use firewall with defaults
      (import ./utils/firewall.nix ({
        config = config;
        pkgs = pkgs;
        enable_localsend = true;
      }))
    ];
  # Bootloader.
  #boot.supportedFilesystems = [ "nfs" ];
  #boot.loader = {
  #timeout = 15;
  #systemd-boot.enable = true;
  #systemd-boot.consoleMode = "keep";
  #efi.canTouchEfiVariables = true;
  #efi.efiSysMountPoint = "/boot/efi";
  #systemd-boot.extraEntries = {
  #"windows.conf" = ''
  #title Windows Boot Manager
  #efi /EFI/MICROSOFT/BOOT/BOOTMGFW.EFI
  #'';
  #
  #};
  #};

  # working boot
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    timeout = 15;
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root $FS_UUID
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Enable networking
  networking.networkmanager.enable = true;
  networking = {
    hostName = "nixos"; # Define your hostname.
  };
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    #displayManager.defaultSession = "plasmawayland";
  };
  hardware.pulseaudio.enable = false;
  # bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.watashi = {
      shell = pkgs.zsh;
      password = "infamous2";
      isNormalUser = true;
      extraGroups = [ "lxd" "networkmanager" "wheel" "video" "audio" "seatd" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
      packages = [ ] ++ (with pkgs; [
        #minecraft
        wev
        emacs
        vulkan-tools
        killall
        sops
        ungoogled-chromium
        age
        lutris
        xdg-desktop-portal-hyprland
      ]);
      # authorized_keys and github keys use same format
      openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = "1qwlx2yxp8ir7ygayn5jlldnb9pbxlkayl44n80ndn2q64lgywv2"; }); in [ ssh_keys ]; # point key files to the thing in nix_store

    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "CascadiaCode" ]; })
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nfs-utils
    distrobox
    wget
    lsof
    hwinfo
    swaybg
    swaylock
    swayidle
    xdg-utils
    mpv
    firefox-wayland
    pavucontrol
    wl-clipboard
    usbutils
    pciutils

  ] ++ [ ripgrep fd tree file binwalk bat ];

  programs = {
    virt-manager.enable = true;
    hyprland = {
      # use hyprland from flake
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      enable = true;
      xwayland = {
        enable = false;
      };
    };
    steam = {
      enable = true;
    };
    direnv = {
      enable = true;
    };
    git = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    xwayland = {
      enable = false;
    };
    dconf = {
      enable = true;
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };
  environment.plasma6.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  security.rtkit.enable = true;
  services = {
    displayManager = {
      sddm.enable = true;
    };
    desktopManager.plasma6 = {
      enable = true;
    };
    rpcbind.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire = {
        context.properties = {
          default.clock.rate = 192000;
          #defautlt.allowed-rates = [ 192000 48000 44100 ];
          defautlt.allowed-rates = [ 192000 ];
        };
      };
    };
    deluge = {
      enable = true;
      package = pkgs.deluge-gtk;
    };
    flatpak = {
      enable = true;
    };
    blueman = {
      enable = true;
    };
  };
  environment = {
    #noXlibs = true;
  };
  #  security = {
  #    doas = {
  #      enable = true;
  #      wheelNeedsPassword = false;
  #      extraRules = [{
  #        users = [ "watashi" ];
  #        keepEnv = true;
  #        setEnv = [ "HOME" "PATH" ];
  #        #persist useless if passwords are disabled
  #        #		persist = true;
  #        noPass = true;
  #      }];
  #    };
  #    pam = {
  #      # based on configuration options below
  #      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/pam.nix
  #      # and
  #      # guide here https://nixos.wiki/wiki/Yubikey
  #      yubico = {
  #        enable = true;
  #        mode = "challenge-response";
  #        id = [ "22728752" ]; # follow yubico-pam guide here, https://nixos.wiki/wiki/Yubikey
  #        debug = false; # enable passwordless not working
  #        control = "sufficient";
  #      };
  #      services = {
  #        sudo.yubicoAuth = true;
  #        doas.yubicoAuth = true;
  #        login.yubicoAuth = true;
  #      };
  #    };
  #  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      allowSFTP = true; # also allows sshfs
      settings = {
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PermitRootLogin = "no";
      };
    };
  };
  virtualisation = {
    docker = {
      enable = true;
    };
    oci-containers = {
      backend = "docker";
    };
    libvirtd = {
      enable = true;
    };
    lxd = {
      enable = true;
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  #nix channel to use
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
}
