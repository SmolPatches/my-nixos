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
    discord
    mako # notifications for wayland
    eza
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
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: with epkgs; [ tsc tree-sitter-langs tree-sitter vterm ];
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "vicmd";
      shellAliases = {
        ll = "eza -l --icons";
        ls = "eza --icons";
      };
      initExtra = ''
        PATH=$PATH:~/.local/bin/
        PATH=$PATH:~/.config/emacs/bin/
        ${builtins.readFile ./extras.zsh}
      '';
      profileExtra = ''
        "${builtins.readFile ./extras.zsh}"
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
      enable = false;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
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
      #"nvim" = { source = ./neovim; };
      "zathura" = { source = ./zathura; };
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
