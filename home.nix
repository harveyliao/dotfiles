{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # User-specific packages (moved from system configuration)
  home.packages = with pkgs; [
    # Modern CLI tools from your dotfiles
    ripgrep # Fast search tool (rg)
    fd # File finder
    bat # Cat with syntax highlighting
    zoxide # better cd
    lazygit # Git TUI
    jq # JSON preview
    fzf # fuzzyfinder
    atuin # shell history sync
    fastfetch # replace neofetch

    # Terminal multiplexer
    zellij # terminal multiplexer

    # Text editors from your dotfiles
    vim # classic editor
    neovim # modern vim
    helix # modern modal editor

    # File managers from your dotfiles
    yazi # modern terminal file manager
    joshuto # ranger-like file manager (alternative)

    # Development tools
    nodejs # for npm updates in your aliases

    # Shell enhancements
    zsh-autosuggestions

    # Optional tools (uncomment if needed)
    # rstudio # R development environment
    # kitty # GPU-accelerated terminal (if not using WSL terminal)
  ];

  # Shell configuration based on your .zshrc
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    # History settings from your .zshrc
    history = {
      size = 5000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;
      append = true;
      ignoreDups = true;
    };
    
    # Your custom aliases from dotfiles
    shellAliases = {
      ll = "ls -la";
      llh = "ls -lah";
      ze = "zellij";
      lg = "lazygit";
      # Keep Fedora aliases for compatibility
      sdi = "sudo dnf install";
      aau = "sudo dnf update -y && sudo npm update";
    };
    
    # Vi mode and other settings from your .zshrc
    initExtra = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Powerlevel10k theme (you'll need to clone this manually or via setup script)
      if [[ -f ~/dotfiles/powerlevel10k/powerlevel10k.zsh-theme ]]; then
        source ~/dotfiles/powerlevel10k/powerlevel10k.zsh-theme
      fi

      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Vi mode (from your .zshrc)
      set -o vi

      # Tool initialization
      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"

      # Yazi wrapper function (from your dotfiles)
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # Additional history settings
      setopt appendhistory
      setopt sharehistory
      setopt incappendhistory
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    # Uncomment and configure with your details
    # userName = "Your Name";
    # userEmail = "your.email@example.com";
    
    # Add any git aliases or settings from your dotfiles here
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Neovim configuration (LazyVim from your dotfiles)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # You can manage plugins here or link to your existing LazyVim config
    # For now, we'll link to your existing config
  };

  # Vim configuration
  programs.vim = {
    enable = true;
    # You can inline your .vimrc content here or link to existing file
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    # Yazi settings will be managed via dotfiles linking
  };

  # Zellij terminal multiplexer
  programs.zellij = {
    enable = true;
    # Zellij settings will be managed via dotfiles linking
  };

  # Kitty terminal (disabled for WSL, enable if needed)
  programs.kitty = {
    enable = false;  # Set to true if you want kitty in WSL
    # Configuration will be managed via dotfiles linking when enabled
  };

  # Helix editor
  programs.helix = {
    enable = true;
    # Settings will be managed via dotfiles linking
  };

  # Atuin shell history
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # Additional atuin settings can be configured here
  };

  # Zoxide smart cd
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";  # You can customize this
    };
  };

  # Fzf fuzzy finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # File associations and dotfile management
  home.file = {
    # Powerlevel10k configuration
    ".p10k.zsh" = {
      source = /home/nixos/dotfiles/p10k/.p10k.zsh;
      # Only create if the source exists
      enable = builtins.pathExists /home/nixos/dotfiles/p10k/.p10k.zsh;
    };

    # Vim configuration
    ".vimrc" = {
      source = /home/nixos/dotfiles/vim/.vimrc;
      enable = builtins.pathExists /home/nixos/dotfiles/vim/.vimrc;
    };

    # Application configurations in .config
    ".config/nvim" = {
      source = /home/nixos/dotfiles/nvim;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/nvim;
    };

    ".config/yazi" = {
      source = /home/nixos/dotfiles/yazi;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/yazi;
    };

    ".config/zellij" = {
      source = /home/nixos/dotfiles/zellij;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/zellij;
    };

    ".config/kitty" = {
      source = /home/nixos/dotfiles/kitty;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/kitty;
    };

    ".config/helix" = {
      source = /home/nixos/dotfiles/helix;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/helix;
    };

    ".config/zed" = {
      source = /home/nixos/dotfiles/zed;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/zed;
    };

    ".config/rstudio" = {
      source = /home/nixos/dotfiles/rstudio;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/rstudio;
    };

    ".config/xournalpp" = {
      source = /home/nixos/dotfiles/xournalpp;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/xournalpp;
    };

    ".config/joshuto" = {
      source = /home/nixos/dotfiles/joshuto;
      recursive = true;
      enable = builtins.pathExists /home/nixos/dotfiles/joshuto;
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    # BROWSER = "firefox";  # Adjust as needed
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
} 