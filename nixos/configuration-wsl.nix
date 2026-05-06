# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    # Core Utilities
    gcc
    git # version control
    curl # download
    wget # download
    htop # resource monitor
    btop # resource monitor
    tree 
    unzip # zip
    p7zip # 7z
    ripgrep # Fast search tool
    fd # File finder
    bat # Cat with syntax highlighting
    zoxide # better cd
    lazygit # Git TUI
    jq # JSON preview
    fzf # fuzzyfinder

    # Development tools
    rustup
    python3

    # Shell and terminal enhancements
    zsh 
    zsh-autosuggestions
    atuin # shell history sync
    fastfetch # replace neofetch
    zellij # terminal multiplexer

    # Text editors (from your dotfiles)
    vim # classic editor
    neovim # modern vim

    # File managers
    yazi # modern terminal file manager

    # Terminal emulator
    # kitty # GPU-accelerated terminal

    # Additional tools from your dotfiles
    # nodejs 
    # rstudio # R development
  ];

  # Enable Zsh as the default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    # Enable additional zsh features
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = false; # use powerlevel10k instead
    };
    interactiveShellInit = ''
      # Initialize tools from your dotfiles
      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"
      
      # Vi mode (from your .zshrc)
      set -o vi
      
      # Aliases from your dotfiles
      alias ll='ls -la'
      alias llh='ls -lah'
      alias ze='zellij'
      alias lg='lazygit'
      
      # Yazi wrapper function (from your dotfiles)
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    # Uncomment and configure if you want system-wide git settings
    # config = {
    #   user.name = "Your Name";
    #   user.email = "your.email@example.com";
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
