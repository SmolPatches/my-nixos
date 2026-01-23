# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs, config, pkgs, ... }:
let
  enable_ipfs = false;
  ghub_hash = "0j05iv8mcwjv10q966zlnnyf11cdq5gmg94m0lacnbdf2jf2gq2k";
  in
{
  # allow hibernation in another life
  #https://wiki.nixos.org/wiki/Power_Management#Hibernation
  # i need to make a swap
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  nixpkgs.overlays = [
    #(final: prev: { grub2 = import ./grub.nix { pkgs = prev; }; })
  ];
  # secrets
  # wip
  # age.secrets = {
  #   nix-code = {
  #     file = ./nix-code.age; # encrypted nix-code (must be nix path type)
  #     owner = "watashi";
  #     # if no path is specified it goes to /run/agenix/nix-code
  #     # which i can pass*
  #     # will be impure but derivation will fail if path doesn't exist
  #     #path = "${inputs.self}/nix-code"; # agenix cant write to nix-store cuz of permissions?
  #     mode = "600";
  #   };
  # };
  #enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./conf/nvidia.nix
      # ./ollama.nix
      ./mullvad.nix
      # (import /run/agenix/nix-code { inherit inputs config pkgs; sV = config.system.stateVersion; }) # use firewall with defaults
      (import ./utils/firewall.nix ({
        config = config;
        pkgs = pkgs;
        enable_localsend = true;
      }))
    ];

  boot = {
    # supportedFilesystems = [ "nfs" ];
    # Bootloader.
    loader = {
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
        splashImage = ./assets/lain.png;
        enable = false; # using lanzboot
      };
      systemd-boot.enable = pkgs.lib.mkForce false;
    };
    #https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking = {
    hostName = "nixos"; # Define your hostname.
  };
  # Set your time zone.
  time.timeZone = "Europe/Rome";
  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.desktopManager.cosmic.enable = true;
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    desktopManager = {
      xterm.enable = true;
    };
    displayManager.gdm.autoSuspend = false; # suspend causes driver issues in gnome
  };
  services.pulseaudio.enable = false;
  # bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = pkgs.lib.mkForce false;
    users.watashi = {
      shell = pkgs.zsh;
      password = "infamous2";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "seatd" "docker" "libvirtd" "tss" ];
      packages = (with pkgs; [
        papers
        ngspice
        tor-browser
        lm_sensors
        fanctl
        mission-center
        hardinfo2
        helix
        nvtopPackages.full
        catppuccin-plymouth
        signal-desktop
        pcmanfm
        prismlauncher # minecraft
        wireguard-tools
        swayimg
        kitty
        moar
        tradingview
        wev
        vulkan-tools
        killall
        age
        xdg-desktop-portal-hyprland
        binutils
      ] ++ [ protonup-qt ] # gaming
      ++ [ # archive utils
        zip
        unzip
        p7zip
        libarchive # bsdtar
      ] ++ [ # alternative launcher for non drm games
        gogdl
        heroic
      ]);
      # authorized_keys and github keys use same format
      openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = ghub_hash; }); in [ ssh_keys ]; # point key files to the thing in nix_store
    };
  };

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    caskaydia-mono
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    mkvtoolnix-cli
    sbctl
    dracula-theme
    dracula-icon-theme
    distrobox
    wget
    hwinfo
    swaybg
    swaylock
    swayidle
    xdg-utils
    mpv
    #firefox-wayland
    pavucontrol
    wl-clipboard
    usbutils
    pciutils
    man-pages
    man-pages-posix
  ] ++ [ ripgrep fd tree file binwalk bat ] ++
  [fuzzel swaylock mako swayidle] ++ # niri stuff? check wiki link below
  [ iperf3 iptables tcpdump nmap netcat-openbsd lsof dig tshark ]; # network monitoring

  programs = {
    localsend.openFirewall = true;
    virt-manager.enable = true;
    waybar.enable = true;
    appimage = {
      # enable = true;
      # binfmt = true;
    };
    #https://wiki.nixos.org/wiki/Niri
    niri = {
      enable = true;
    };
    hyprland = {
      # use hyprland from flake
      #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      package = inputs.nixpkgs.legacyPackages."x86_64-linux".hyprland;
      enable = true;
      xwayland = {
        enable = true;
      };
    };

    # https://wiki.archlinux.org/title/Gamescope
    gamescope = {
      enable = true;
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
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
      enable = true;
    };
    dconf = {
      enable = true;
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
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
    gedit # text editor
    #]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
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
  # security.rtkit.enable = true;
  security.polkit.enable = true;
  # https//nixos.wiki/wiki/NixOS_Containers
  # use to separate services(good for sec)
  containers = let stateVersion = config.system.stateVersion; in {
    # torrent server and interface
    torrent-server = {
      config = { config, pkgs, lib, ... }: {
        system.stateVersion = stateVersion;
        #system.stateVersion = "23.05";
        services = {
          deluge = {
            enable = true;
            web = {
              enable = true;
              openFirewall = true;
            };
          };
        };
      };
    };
  };
  services = {
    #crab-hole.enable = true;
    kubo = {
      enable = enable_ipfs;
    };
    whoogle-search.enable = true;
    gnome = {
      core-apps.enable = pkgs.lib.mkForce false;
      core-os-services.enable = pkgs.lib.mkForce true; # settings?
      core-shell.enable = pkgs.lib.mkForce false;
    };
    displayManager = {
      #sddm.enable = true;
      ly = {
        enable = true;
        settings = {
          vi_mode = true;
        };
      };
    };
    desktopManager.plasma6 = {
      enable = false;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    rpcbind.enable = true; # for nfs i think
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
      # wireplumber.extraConfig.bluetoothEnhancements = {
      #   "monitor.bluez.properties" = {
      #     "bluez5.enable-sbc-xq" = true;
      #     "bluez5.enable-msbc" = true;
      #     "bluez5.enable-hw-volume" = true;
      #     "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      #   };
      # };
    };
    flatpak = {
      enable = true;
    };
    blueman = {
      enable = true;
    };
    syncthing = {
      enable = true;
      user = "watashi";
      dataDir = "/home/watashi/sink/";
      configDir = "/home/watashi/sink/.config/syncthing";
    };
  };
  environment = {
    #noXlibs = true;
    variables = {
      RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/.rgrc";
      GTK_THEME = "Dracula:dark";
      EMACS_HOME = "$HOME/.config/emacs/";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
    #style = "adwaita-dark";
  };
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    pki = {
      # certificateFiles = [ ./conf/certs/cert.pem ];
    };
    pam.yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
      #nix-shell --command 'ykinfo -s' -p yubikey-personalization
      id = [
        "22728752"
      ];
    };
    # nix-shell -p yubico-pam -p yubikey-manager
    # ykman otp chalresp --touch --generate 2 # remove --touch for no interaction
    # ykpamcfg -2 -v
  };

  services = {
    gnome.gnome-keyring.enable = true;
    # Enable the OpenSSH daemon.
    emacs = {
      package = pkgs.emacs30-pgtk;
      enable = true;
      install = true;
      defaultEditor = true;
    };
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
    podman = {
      enable = true;
    };
    oci-containers = {
      backend = "podman";
    };
    libvirtd = {
      enable = true;
    };
    virtualbox.guest.enable = false;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  #
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };

  # xdg stuff
  #xdg.portal.wlr.enable = pkgs.lib.mkForce true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  #nix channel to use
  #system.autoUpgrade.channel.enable = true;
  #system.autoUpgrade.channel.allowReboot = true;
  #system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
}
