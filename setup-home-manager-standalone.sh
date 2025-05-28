#!/bin/bash

echo "🏠 Setting up dotfiles with Home Manager (Standalone Method)..."

# Check if we're on NixOS
if ! command -v nixos-rebuild &> /dev/null; then
    echo "❌ This script is designed for NixOS. Please run on a NixOS system."
    exit 1
fi

# First, let's update the system configuration without Home Manager
echo "📋 Copying system configuration..."
sudo cp ~/dotfiles/configuration.nix /etc/nixos/configuration.nix.backup
echo "✅ Backup created at /etc/nixos/configuration.nix.backup"

# Create a temporary configuration.nix without Home Manager integration
echo "🔧 Creating temporary system configuration without Home Manager..."
cat > /tmp/temp-configuration.nix << 'EOF'
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
    # Core system utilities only
    gcc
    git # version control (system-wide)
    curl # download
    wget # download
    htop # resource monitor
    btop # resource monitor
    tree 
    unzip # zip
    p7zip # 7z
    
    # Essential system tools
    zsh # shell (system-wide)
    
    # Keep these system-wide for all users
    rustup # system-wide rust toolchain
    python3 # system-wide python
  ];

  # Enable Zsh as the default shell (system-wide)
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Enable experimental features for Home Manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
EOF

sudo cp /tmp/temp-configuration.nix /etc/nixos/configuration.nix

# Apply the basic system configuration first
echo "🔄 Applying basic system configuration..."
sudo nixos-rebuild switch

# Install Home Manager standalone
echo "📦 Installing Home Manager (standalone)..."
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update

# Install Home Manager
echo "🏠 Installing Home Manager..."
nix-shell '<home-manager>' -A install

# Clone powerlevel10k if it doesn't exist
TARGET_DIR="$HOME/dotfiles/powerlevel10k"
if [ ! -d "$TARGET_DIR" ]; then
    echo "📥 Cloning Powerlevel10k..."
    git clone https://github.com/romkatv/powerlevel10k.git "$TARGET_DIR"
    echo "✅ Powerlevel10k cloned into $TARGET_DIR"
else
    echo "✅ Powerlevel10k already exists at $TARGET_DIR"
fi

# Create Home Manager config directory
mkdir -p ~/.config/home-manager

# Copy home.nix to the Home Manager config directory
echo "📋 Setting up Home Manager configuration..."
cp ~/dotfiles/home.nix ~/.config/home-manager/home.nix

# Apply Home Manager configuration
echo "🔄 Applying Home Manager configuration..."
home-manager switch

# Check if Home Manager setup was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Setup complete! Your dotfiles are now managed by Home Manager (standalone)."
    echo ""
    echo "📝 What happened:"
    echo "   • System packages managed by /etc/nixos/configuration.nix"
    echo "   • User packages and configs managed by Home Manager"
    echo "   • Dotfiles linked declaratively via ~/.config/home-manager/home.nix"
    echo ""
    echo "🔧 To make changes:"
    echo "   • Edit ~/.config/home-manager/home.nix for user configurations"
    echo "   • Edit /etc/nixos/configuration.nix for system configurations"
    echo "   • Run 'home-manager switch' to apply user changes"
    echo "   • Run 'sudo nixos-rebuild switch' to apply system changes"
    echo ""
    echo "📚 Useful commands:"
    echo "   • home-manager generations  # List previous configurations"
    echo "   • home-manager switch --rollback  # Rollback to previous"
    echo "   • home-manager switch  # Apply user changes"
    echo "   • sudo nixos-rebuild switch  # Apply system changes"
else
    echo "❌ Home Manager setup failed. Please check the configuration and try again."
    echo "💡 You can check the configuration with: home-manager build"
    exit 1
fi 