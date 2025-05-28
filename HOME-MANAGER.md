# 🏠 Home Manager Setup Guide

This guide will help you set up Home Manager to manage your user-specific configurations declaratively, complementing your NixOS system configuration.

## 🤔 What is Home Manager?

Home Manager allows you to manage your user environment (dotfiles, applications, services) using Nix expressions. It's perfect for:
- Managing dotfiles declaratively
- User-specific package installations
- Service configurations (like systemd user services)
- Shell configurations and themes

## 🚀 Installation

### Method 1: Standalone Installation (Recommended for beginners)

1. **Add the Home Manager channel:**
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
```

2. **Install Home Manager:**
```bash
nix-shell '<home-manager>' -A install
```

3. **Verify installation:**
```bash
home-manager --version
```

### Method 2: NixOS Module Integration

Add to your `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:
{
  # Enable flakes (add this to your existing configuration)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Add home-manager
  imports = [
    <home-manager/nixos>
    # ... your existing imports
  ];

  home-manager.users.nixos = { pkgs, ... }: {
    home.stateVersion = "24.11";
    # Your home-manager configuration goes here
  };
}
```

## 📁 Configuration Structure

Create your Home Manager configuration file:

```bash
# Create the config directory
mkdir -p ~/.config/home-manager

# Create the main configuration file
touch ~/.config/home-manager/home.nix
```

## 🔧 Basic Home Manager Configuration

Here's a starter `home.nix` based on your dotfiles:

```nix
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # User-specific packages (these will be removed from system configuration)
  home.packages = with pkgs; [
    # Development tools
    nodejs
    
    # Optional tools from your dotfiles
    helix
    joshuto
    
    # Any other user-specific packages
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    # Your custom aliases from dotfiles
    shellAliases = {
      ll = "ls -la";
      llh = "ls -lah";
      ze = "zellij";
      lg = "lazygit";
      sdi = "sudo dnf install";  # Keep for compatibility
      aau = "sudo dnf update -y && sudo npm update";
    };
    
    # Vi mode and other settings
    initExtra = ''
      # Vi mode (from your .zshrc)
      set -o vi
      
      # Initialize tools
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
      
      # History settings from your .zshrc
      HISTSIZE=5000
      HISTFILE=~/.zsh_history
      SAVEHIST=10000
      setopt appendhistory
      setopt sharehistory
      setopt incappendhistory
    '';
  };

  # Powerlevel10k theme
  programs.zsh.oh-my-zsh = {
    enable = false;  # We'll use powerlevel10k directly
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    # Add your git aliases and settings here
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # You can manage your neovim config here or link to your existing config
  };

  # Vim configuration
  programs.vim = {
    enable = true;
    # You can inline your .vimrc content here or use extraConfig
  };

  # File manager configurations
  programs.yazi = {
    enable = true;
    # Yazi settings can be configured here
  };

  # Terminal multiplexer
  programs.zellij = {
    enable = true;
    # Zellij configuration
  };

  # Kitty terminal (if you decide to use it)
  programs.kitty = {
    enable = false;  # Set to true if you want kitty in WSL
    # theme = "Dracula";
    # settings = {
    #   font_family = "FiraCode Nerd Font";
    #   font_size = 12;
    # };
  };

  # File associations and dotfile management
  home.file = {
    # Link your existing dotfiles
    ".p10k.zsh".source = ./dotfiles/p10k/.p10k.zsh;
    
    # You can also manage other config files
    # ".config/yazi".source = ./dotfiles/yazi;
    # ".config/zellij".source = ./dotfiles/zellij;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
```

## 🔄 Migrating Your Dotfiles

### Step 1: Update Your System Configuration

Remove user-specific packages from `/etc/nixos/configuration.nix` and move them to Home Manager:

```nix
# In /etc/nixos/configuration.nix - REMOVE these from systemPackages:
# nodejs, helix, (any user-specific tools)

# Keep only system-wide tools:
environment.systemPackages = with pkgs; [
  # Core system utilities
  gcc
  git
  curl
  wget
  htop
  btop
  tree
  unzip
  p7zip
  ripgrep
  fd
  bat
  zoxide
  lazygit
  jq
  fzf
  rustup
  python3
  zsh
  zsh-autosuggestions
  atuin
  fastfetch
  zellij
  vim
  neovim
  yazi
];
```

### Step 2: Create Home Manager Dotfiles Structure

```bash
# Create a home-manager directory in your dotfiles
mkdir -p ~/dotfiles/home-manager

# Copy your existing configs
cp -r ~/dotfiles/nvim ~/dotfiles/home-manager/
cp -r ~/dotfiles/yazi ~/dotfiles/home-manager/
cp -r ~/dotfiles/zellij ~/dotfiles/home-manager/
# ... etc for other configs
```

### Step 3: Advanced Home Manager Configuration

Create `~/dotfiles/home-manager/home.nix`:

```nix
{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "24.11";

  # Import modular configurations
  imports = [
    ./programs/zsh.nix
    ./programs/neovim.nix
    ./programs/git.nix
    # Add more modules as needed
  ];

  # User packages
  home.packages = with pkgs; [
    nodejs
    helix
    joshuto
  ];

  # Dotfile management
  home.file = {
    ".p10k.zsh".source = ../p10k/.p10k.zsh;
    ".config/yazi".source = ../yazi;
    ".config/zellij".source = ../zellij;
    ".config/kitty".source = ../kitty;
  };

  programs.home-manager.enable = true;
}
```

### Step 4: Modular Configuration Files

Create `~/dotfiles/home-manager/programs/zsh.nix`:

```nix
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    shellAliases = {
      ll = "ls -la";
      llh = "ls -lah";
      ze = "zellij";
      lg = "lazygit";
    };
    
    initExtra = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Powerlevel10k theme
      source ~/dotfiles/powerlevel10k/powerlevel10k.zsh-theme

      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Vi mode
      set -o vi

      # Tool initialization
      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"

      # Yazi wrapper function
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
}
```

## 🚀 Usage Commands

### Basic Operations

```bash
# Apply configuration
home-manager switch

# Check what would change
home-manager build

# Rollback to previous generation
home-manager generations
home-manager switch --rollback

# Update packages
nix-channel --update
home-manager switch
```

### Managing Generations

```bash
# List all generations
home-manager generations

# Remove old generations
home-manager expire-generations "-7 days"

# Garbage collect
nix-collect-garbage -d
```

## 🔧 Integration with Your Existing Setup

### Update Your setup.sh

Modify your `setup.sh` to work with Home Manager:

```bash
#!/bin/bash

echo "Setting up dotfiles with Home Manager..."

# Clone powerlevel10k if it doesn't exist
TARGET_DIR="$HOME/dotfiles/powerlevel10k"
if [ ! -d "$TARGET_DIR" ]; then
  git clone https://github.com/romkatv/powerlevel10k.git "$TARGET_DIR"
  echo "Powerlevel10k cloned into $TARGET_DIR"
fi

# Link home-manager configuration
ln -sf ~/dotfiles/home-manager/home.nix ~/.config/home-manager/home.nix

# Apply home-manager configuration
home-manager switch

echo "Setup complete! Your dotfiles are now managed by Home Manager."
```

## 🎯 Benefits of Home Manager

1. **Declarative Configuration**: Your entire user environment is reproducible
2. **Atomic Updates**: Rollback capability for user configurations
3. **Modular Organization**: Split configurations into logical modules
4. **Version Control**: Your entire setup is in git
5. **Cross-Machine Sync**: Same config works on multiple machines

## 🐛 Troubleshooting

### Common Issues

**Home Manager not found:**
```bash
# Re-add the channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
```

**Configuration conflicts:**
```bash
# Remove conflicting files
rm ~/.zshrc  # if it exists as a regular file
home-manager switch
```

**Powerlevel10k not loading:**
```bash
# Ensure the path is correct in your home.nix
# The powerlevel10k should be cloned to ~/dotfiles/powerlevel10k
```

## 📚 Next Steps

1. **Start Simple**: Begin with the basic configuration
2. **Migrate Gradually**: Move one tool at a time to Home Manager
3. **Modularize**: Split your configuration into logical modules
4. **Explore Options**: Check `home-manager options` for available settings
5. **Join Community**: NixOS Discord/Reddit for help and tips

---

*This guide helps you transition from traditional dotfiles to a fully declarative user environment with Home Manager.* 