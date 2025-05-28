# 🏠 Fedora Dotfiles

A comprehensive collection of configuration files (dotfiles) for a modern Linux development environment, originally created on Fedora. This repository contains carefully curated configurations for various tools and applications to create a productive and aesthetically pleasing workspace.

## 🚀 Quick Start

### For NixOS (Recommended)
```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Copy the NixOS configuration files
sudo cp configuration.nix /etc/nixos/
sudo cp home.nix /etc/nixos/

# Run the Home Manager setup script
chmod +x setup-home-manager.sh
./setup-home-manager.sh
```

### For Traditional Linux (Fedora/Ubuntu/etc.)
```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the traditional setup script
chmod +x setup.sh
./setup.sh
```

## 📦 What's Included

### 🐚 Shell Configuration
- **Zsh** - Modern shell with advanced features
  - Custom aliases and functions
  - History management and sharing
  - Vi-mode keybindings
  - Integration with modern CLI tools
- **Bash** - Fallback shell configuration
  - Basic aliases and PATH configuration
  - Cargo environment setup
- **Powerlevel10k** - Beautiful and fast Zsh theme
  - Instant prompt for faster shell startup
  - Customizable prompt segments

### 📝 Text Editors
- **Neovim** - Modern Vim-based editor
  - LazyVim configuration for enhanced productivity
  - Plugin management with lazy.nvim
  - Comprehensive language support
- **Vim** - Classic text editor
  - Sensible defaults and keybindings
  - Relative line numbers
  - Enhanced search and navigation
- **Helix** - Modern modal editor
  - Minimal configuration for quick editing
- **Zed** - Fast, collaborative code editor
  - Custom keybindings and settings

### 🖥️ Terminal & Multiplexing
- **Kitty** - GPU-accelerated terminal emulator
  - Custom theme and extensive configuration
  - Optimized for performance and aesthetics
- **Zellij** - Modern terminal multiplexer
  - Rust-based alternative to tmux
  - Intuitive keybindings and layouts

### 📁 File Management
- **Yazi** - Modern terminal file manager
  - Fast and intuitive navigation
  - Custom themes and keybindings
  - Plugin support and bookmarks
  - Shell integration for directory changing
- **Joshuto** - Ranger-like file manager (alternative)

### 🔧 Development Tools
- **RStudio** - R development environment configuration
- **Xournalpp** - Note-taking application settings

### 🛠️ Modern CLI Tools Integration
The configuration includes integration with several modern CLI tools:
- **Atuin** - Enhanced shell history
- **Zoxide** - Smart directory jumping
- **Lazygit** - Terminal UI for Git
- **UV** - Fast Python package manager (commented)
- **Zsh Autosuggestions** - Command completion

## 📋 Prerequisites

Before running the setup script, ensure you have the following tools installed:

### Essential Tools
```bash
# Fedora/RHEL/CentOS
sudo dnf install zsh git vim neovim kitty

# For other distributions, use your package manager
```

### Modern CLI Tools
```bash
# Install modern CLI tools
sudo dnf install zoxide

# Install via cargo (if you have Rust)
cargo install yazi-fm zellij helix-term

# Install atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

### Zsh Plugins
```bash
# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

## 🔧 Installation Details

The `setup.sh` script performs the following actions:

1. **Clones Powerlevel10k** theme to `~/dotfiles/powerlevel10k`
2. **Creates symlinks** for configuration files:
   - Shell configs (`~/.zshrc`, `~/.bashrc`, etc.)
   - Editor configs (`~/.vimrc`)
   - Application configs in `~/.config/`

### Symlinked Files

#### Home Directory
- `~/.bashrc` → `~/dotfiles/bash/.bashrc`
- `~/.bash_profile` → `~/dotfiles/bash/.bash_profile`
- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`
- `~/.zshenv` → `~/dotfiles/zsh/.zshenv`
- `~/.vimrc` → `~/dotfiles/vim/.vimrc`
- `~/.p10k.zsh` → `~/dotfiles/p10k/.p10k.zsh`

#### ~/.config Directory
- `~/.config/kitty/` → `~/dotfiles/kitty/`
- `~/.config/nvim/` → `~/dotfiles/nvim/`
- `~/.config/yazi/` → `~/dotfiles/yazi/`
- `~/.config/zellij/` → `~/dotfiles/zellij/`
- `~/.config/zed/` → `~/dotfiles/zed/`
- `~/.config/rstudio/` → `~/dotfiles/rstudio/`
- `~/.config/xournalpp/` → `~/dotfiles/xournalpp/`
- `~/.config/joshuto/` → `~/dotfiles/joshuto/`

## 🎨 Key Features

### Shell Enhancements
- **Smart History**: Shared history across sessions with Atuin integration
- **Directory Navigation**: Quick jumping with Zoxide (`z` command)
- **File Management**: Yazi integration with `y()` function for directory changing
- **Git Integration**: Lazygit alias (`lg`) for terminal-based Git operations

### Useful Aliases
```bash
ll='ls -la'           # Detailed file listing
llh='ls -lah'         # Human-readable file sizes
sdi='sudo dnf install' # Quick package installation
aau='sudo dnf update -y && sudo npm update' # System and npm updates
ze='zellij'           # Quick terminal multiplexer
lg='lazygit'          # Git terminal UI
```

### Editor Features
- **Neovim**: LazyVim distribution with modern plugins and LSP support
- **Vim**: Sensible defaults with relative line numbers and improved search
- **Helix**: Modal editing with built-in LSP and tree-sitter support

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull origin main
# Re-run setup if needed
./setup.sh
```

## 🛡️ Backup

Before installation, consider backing up your existing configurations:

```bash
# Backup existing configs
mkdir ~/dotfiles-backup
cp ~/.zshrc ~/dotfiles-backup/ 2>/dev/null || true
cp ~/.vimrc ~/dotfiles-backup/ 2>/dev/null || true
cp -r ~/.config/nvim ~/dotfiles-backup/ 2>/dev/null || true
# Add other configs as needed
```

## 🎯 Customization

### Adding New Configurations
1. Create a new directory for your tool: `mkdir ~/dotfiles/newtool`
2. Add your configuration files
3. Update `setup.sh` to create the appropriate symlinks
4. Update this README

### Modifying Existing Configs
Simply edit the files in the dotfiles directory. Changes will be reflected immediately due to symlinks.

## 🐛 Troubleshooting

### Common Issues

**Zsh not loading properly:**
```bash
# Ensure zsh is your default shell
chsh -s $(which zsh)
```

**Powerlevel10k not working:**
```bash
# Re-run the p10k configuration
p10k configure
```

**Symlinks not working:**
```bash
# Check if files exist and remove if necessary
ls -la ~/.zshrc
rm ~/.zshrc  # if it's a regular file
./setup.sh   # re-run setup
```

## 📄 License

This project is open source. Feel free to use, modify, and distribute as needed.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

---

*Created for Fedora Linux but adaptable to other distributions.*