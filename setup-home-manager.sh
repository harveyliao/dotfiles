#!/bin/bash

echo "🏠 Setting up dotfiles with Home Manager..."

# Check if we're on NixOS
if ! command -v nixos-rebuild &> /dev/null; then
    echo "❌ This script is designed for NixOS. Please run on a NixOS system."
    exit 1
fi

# Check if Home Manager channel exists
if ! nix-channel --list | grep -q "home-manager"; then
    echo "📦 Adding Home Manager channel..."
    
    # Add Home Manager channel for both user and root
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
    sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
    
    echo "🔄 Updating channels..."
    nix-channel --update
    sudo nix-channel --update
    
    echo "✅ Home Manager channel added for both user and root"
else
    echo "✅ Home Manager channel already exists"
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

# Verify that Home Manager is available in NIX_PATH
echo "🔍 Verifying Home Manager availability..."
if ! nix-instantiate --eval -E '<home-manager>' &> /dev/null; then
    echo "❌ Home Manager not found in NIX_PATH. Trying to fix..."
    
    # Export NIX_PATH to include home-manager
    export NIX_PATH="$NIX_PATH:home-manager=/nix/var/nix/profiles/per-user/root/channels/home-manager"
    
    # Try again
    if ! nix-instantiate --eval -E '<home-manager>' &> /dev/null; then
        echo "❌ Still can't find Home Manager. Please run the following commands manually:"
        echo "   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager"
        echo "   sudo nix-channel --update"
        echo "   sudo nixos-rebuild switch"
        exit 1
    fi
fi
echo "✅ Home Manager is available"

# Test the configuration first
echo "🧪 Testing NixOS configuration..."
if ! sudo nixos-rebuild dry-build; then
    echo "❌ Configuration test failed. Please check your configuration files."
    echo "💡 Common issues:"
    echo "   • Check that /etc/nixos/configuration.nix imports home-manager correctly"
    echo "   • Verify that /etc/nixos/home.nix exists and is valid"
    echo "   • Make sure all dotfile paths in home.nix exist"
    exit 1
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