#!/bin/bash

echo "🏠 Setting up dotfiles with Home Manager..."

# Check if we're on NixOS
if ! command -v nixos-rebuild &> /dev/null; then
    echo "❌ This script is designed for NixOS. Please run on a NixOS system."
    exit 1
fi

# Check if Home Manager is available
if ! command -v home-manager &> /dev/null; then
    echo "📦 Installing Home Manager..."
    
    # Add Home Manager channel
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
    nix-channel --update
    
    echo "✅ Home Manager channel added"
fi

# Clone powerlevel10k if it doesn't exist
TARGET_DIR="$HOME/dotfiles/powerlevel10k"
if [ ! -d "$TARGET_DIR" ]; then
    echo "📥 Cloning Powerlevel10k..."
    git clone https://github.com/romkatv/powerlevel10k.git "$TARGET_DIR"
    echo "✅ Powerlevel10k cloned into $TARGET_DIR"
else
    echo "✅ Powerlevel10k already exists at $TARGET_DIR"
fi

# Copy home.nix to /etc/nixos/ if it doesn't exist there
if [ ! -f "/etc/nixos/home.nix" ]; then
    echo "📋 Copying home.nix to /etc/nixos/..."
    sudo cp ~/dotfiles/home.nix /etc/nixos/home.nix
    echo "✅ home.nix copied to /etc/nixos/"
fi

# Rebuild NixOS configuration (this will also apply Home Manager)
echo "🔄 Rebuilding NixOS configuration with Home Manager..."
sudo nixos-rebuild switch

# Check if rebuild was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Setup complete! Your dotfiles are now managed by Home Manager."
    echo ""
    echo "📝 What happened:"
    echo "   • System packages moved to /etc/nixos/configuration.nix"
    echo "   • User packages and configs managed by Home Manager"
    echo "   • Dotfiles linked declaratively via home.nix"
    echo ""
    echo "🔧 To make changes:"
    echo "   • Edit /etc/nixos/home.nix for user configurations"
    echo "   • Edit /etc/nixos/configuration.nix for system configurations"
    echo "   • Run 'sudo nixos-rebuild switch' to apply changes"
    echo ""
    echo "📚 Useful commands:"
    echo "   • home-manager generations  # List previous configurations"
    echo "   • home-manager switch --rollback  # Rollback to previous"
    echo "   • nixos-rebuild switch  # Apply system + home changes"
else
    echo "❌ NixOS rebuild failed. Please check the configuration and try again."
    echo "💡 You can check the configuration with: sudo nixos-rebuild dry-build"
    exit 1
fi 