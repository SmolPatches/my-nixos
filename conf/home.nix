{ config, pkgs, ... }: {

  # TODO
  # configure wofi/rofi
  # eww

  # home-manager.users.rob = {
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    neofetch
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
    rpcs3
    pcsx2
    libreoffice
    #x org packages
    feh
    rofi
    #wayland packages
    wofi
  ];
  home.file = {
    # cwmrc
    ".cwmrc" = {
      enable = true;
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
      defaultEditor = false;
      extraLuaConfig = builtins.readFile ./neovim/init.lua;
      extraPackages = with pkgs; [
    #    # extra packages neovim would need
    #    # like lsps and things
    #    # i chose not to install these but instead have dev flakes install them
    #    # this means lsp must conditionally check to see if the required commands are present on system before attaching
      ];
    #  plugins = with pkgs.vimPlugins; [
    #    zig-vim
    #    trouble-nvim
        plenary-nvim
        telescope-nvim
        nvim-lspconfig
        nvim-cmp
        lualine-nvim
    #    cmp-buffer
    #    cmp-path
    #    cmp-nvim-lsp
    #    cmp-nvim-lua
    #    gitsigns-nvim
    #    gruvbox-nvim
        nvim-treesitter
    #    nvim-tree-lua
    #  ];
    #};
    tmux = {
      enable = true;
    };
    vscode = {
      package = pkgs.vscodium.fhs;
      enable = true;
      userSettings = {
        "editor.fontFamily" = "'Caskaydia Nerd Font Mono'";
        "editor.fontSize" = 14;
      };
      extensions = with pkgs.vscode-extensions;[
        vscodevim.vim
        mkhl.direnv
        matklad.rust-analyzer
        tiehuis.zig
      ];
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
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      #package = pkgs.emacs-nox;
      extraPackages = epkgs: (with epkgs; [ evil nix-mode nixos-options editorconfig rustic treemacs-evil lsp-ui company darkokai-theme adwaita-dark-theme ]);
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
  home.sessionVariables = {
    EDITOR = "emacslient";
  };
  gtk = {
    enable = pkgs.lib.mkForce true;
    font = pkgs.lib.mkForce {
      package = (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; });
      name = " CaskaydiaCove Nerd Font Mono";
      size = 14;
    };
    gtk3.extraConfig = pkgs.lib.mkForce {
      gtk-application-prefer-dark-theme = true;
    };
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
