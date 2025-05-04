{ config, pkgs, ... }:
let
  useEmacs = false;
  useNvim = false;
  useMoar = true;
  enableManColors = true;
  defaultEditor = if useEmacs then "emacsclient" else if useNvim then "nvim" else "hx";
in
{

  # TODO
  # configure wofi/rofi
  # eww
  # home-manager.users.rob = {
  /* The home.stateVersion option does not have a default and must be set */
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    neofetch
    #discord
    mako # notifications for wayland
    eza
    localsend
    yaml-language-server
    nil
    nixpkgs-fmt
    moar
    yacreader
    htop
    qbittorrent
    keepassxc
    tmux
    (neovim-qt.override { neovim = config.programs.neovim.finalPackage; })
    rpcs3
    #x org packages
    feh
    rofi
    #wayland packages
    wofi
  ] ++ (with nodePackages; [ bash-language-server vscode-langservers-extracted ]);
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
      aliases = {
        l1 = "log --oneline";
        last = "log -1 HEAD";
      };
      extraConfig = {
        core = {
          defaultBranch = "trunk";
          #editor = defaultEditor;
        };
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
      defaultEditor = useNvim;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        pkgs.vimPlugins.lsp-zero-nvim
      ];
    };
    tmux = {
      # comes with preset binding, i don't want it.
      enable = false;
    };
    vscode = {
      enable = false;
      package = pkgs.vscode.fhs;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
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
        function killwb {
          ps aux | grep waybar$ | awk '{print $2}' | xargs kill
        }
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
    EDITOR = defaultEditor;
    PAGER = pkgs.lib.mkForce (if useMoar then "${pkgs.lib.getExe pkgs.moar}" else "less");
    GROFF_NO_SGR = if enableManColors then 1 else 0;
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
      #"nvim" = { source = ./neovim; }; # i use a separate repo
      "zathura" = { source = ./zathura; };
      "tmux" = { source = ./tmux; };
      "helix" = { source = ./helix; };
      "alacritty" = { source = ./alacritty; };
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
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     openssh = prev.openssh.override {
  #       hpnSupport = true;
  #       withKerberos = true;
  #       kerberos = final.libkrb5;
  #     };
  #   })
  # ];
}
