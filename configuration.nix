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
    # Core Util
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
    # atuin # shell history sync
    fastfetch # replace neofetch
    zellij # terminal multiplexer

    # text editor
    neovim

    # file manager
    yazi

  ];

  # Enable Zsh as the default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true; # Enables zsh-autosuggestions
    # Optionally, enable other zsh plugins or settings
    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
