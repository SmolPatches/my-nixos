{ config, pkgs, ... }: {

  # TODO
  # configure wofi/rofi
  # eww

  # home-manager.users.rob = {
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    irssi
    xclip
    yazi
    signal-desktop
    neofetch
    nheko
    discord
    eza
    rnix-lsp
    localsend
    yaml-language-server
    zls
    nixpkgs-fmt
    moar
    yacreader
    htop
    thunderbird
    qbittorrent
    keepassxc
    (neovim-qt.override { neovim = config.programs.neovim.finalPackage; })
    rpcs3
    libreoffice
    #x org packages
    feh
    rofi
    #wayland packages
    wofi
  ];
  home.file = {
    ".cwmrc" = {
      # use cwm
      enable = false;
      source = ./cwmrc;
    };
  };
  programs = {
    git = {
      enable = true;
      ignores = [ "*.*~" "#*#" ];
      userEmail = "rob73hall@gmail.com";
      userName = "mdnlss";
      extraConfig = {
        core = { defaultBranch = "trunk"; };
      };
      difftastic = {
        enable = true;
        background = "dark";
      };
    };
    neovim = {
      enable = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      defaultEditor = true;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };
    tmux = {
      enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "vicmd";
      shellAliases = {
        ll = "eza -Fxl --icons";
        ls = "eza --icons";
      };
      initExtra = ''
        PATH=$PATH:~/.local/bin/
      '';
    };
    nushell = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [ "--exact" ];
    };
    starship = {
      enable = false;
      enableZshIntegration = false;
    };
    alacritty = {
      enable = true;
    };
    foot = {
      enable = true;
      settings = {
        main = {
          font = "Hack:size=11";
          dpi-aware = "yes";
        };
      };
    };
    emacs = {
      enable = true;
      #package = pkgs.emacs29-pgtk;
    };
    zathura = {
      enable = true;
    };
    lf = {
      enable = true;
    };
    librewolf = {
      enable = true;
    };
    rofi = {
      enable = true;
    };
    eww = {
      enable = false;
    };
    waybar = {
      enable = true;
    };
  };
  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  services = {
    emacs = {
      enable = true;
      startWithUserSession = true;
    };
  };
  xdg = {
    configFile = {
      "hypr" = { source = ./hypr; };
      "wallpapers" = { source = ./wallpapers; };
      "nvim" = { source = ./neovim; };
    };
  };
  # desktopEntries = {
  # steam = {
  # name = "Steam";
  # exec = "steam -w 2160 -h 1440 %U";
  # type = "Application";
  # categories = [ "Game" ];
  # terminal = false;
  # mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
  # prefersNonDefaultGPU = true;
  # };
  # };
  # this was a test idek what this does
  # https://rycee.gitlab.io/home-manager/options.html#opt-nixpkgs.overlays
  nixpkgs.overlays = [
    (final: prev: {
      openssh = prev.openssh.override {
        hpnSupport = true;
        withKerberos = true;
        kerberos = final.libkrb5;
      };
    })
  ];
}
