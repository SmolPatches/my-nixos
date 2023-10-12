# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  #enable flakes
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./conf/nvidia.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # use latest linux
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # downgrade kernel to test wifi changes
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking = {
    hostName = "nixos"; # Define your hostname.
    firewall = {
      enable = true;
      # ssh and searxng docker and whoogle
      allowedTCPPorts = [ 22 80 8080 8081 ];
    };
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
    layout = "us";
    xkbVariant = "";
    enable = true;
    windowManager = {
      cwm.enable = true;
    };
    displayManager = {
      startx.enable = true;
    };
  };
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
      hashedPassword = "$y$j9T$/9B9a0OrsQpd5BAniXssM.$kuA1aZ4odb8738jr/TGzBlYIvPQXV7l5C5dmdIWseJ7";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "seatd" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        virt-manager
        vulkan-tools
        killall
        qt5ct
        age
        xdg-desktop-portal-hyprland
        adwaita-qt
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMqnUtVfxGgzVD/rsHOhZphgSTztDjTxCdZ4yJkr4zQ r3b@eldnmac.resource.campus.njit.edu"
      ];
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "CascadiaCode" ]; })
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    lsof
    screen
    swaybg
    swaylock
    swayidle
    xdg-utils
    mpv
    bat
    exa
    ripgrep
    firefox-wayland
    pavucontrol
    wl-clipboard
    tree
    file
    binwalk
    yubikey-personalization
    usbutils
    pciutils

  ] ++
  # install glxinfo if xwayland is enabled
  (if config.programs.hyprland.xwayland.enable then [ glxinfo ] else [ ]);

  programs = {
    hyprland = {
      # use hyprland from flake
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      enable = true;
      xwayland = {
        hidpi = false;
        enable = false;
      };
      nvidiaPatches = true;
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
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
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
  environment.sessionVariables = {

  };
  security = {
    doas = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [{
        users = [ "watashi" ];
        keepEnv = true;
        setEnv = [ "HOME" "PATH" ];
        #persist useless if passwords are disabled
        #		persist = true;
        noPass = true;
      }];
    };
    pam = {
      # based on configuration options below
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/pam.nix
      # and
      # guide here https://nixos.wiki/wiki/Yubikey
      yubico = {
        enable = true;
        mode = "challenge-response";
        id = [ "22728752" ]; # follow yubico-pam guide here, https://nixos.wiki/wiki/Yubikey
        debug = false; # enable passwordless not working
        control = "sufficient";
      };
      services = {
        sudo.yubicoAuth = true;
        doas.yubicoAuth = true;
        login.yubicoAuth = true;
      };
    };

  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
    #yubikey smartcard stuff
    pcscd = {
      enable = true;
    };
    udev = {
      packages = with pkgs;[ yubikey-personalization ];
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
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = pkgs.lib.mkForce "bb10dark";
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
