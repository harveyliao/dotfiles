# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply harveyliao
```

## Per-Machine Setup

Create `~/.config/chezmoi/chezmoi.toml` on each machine. See
`docs/chezmoi.toml.example` for the template.

```bash
mkdir -p ~/.config/chezmoi
cp docs/chezmoi.toml.example ~/.config/chezmoi/chezmoi.toml
# Edit the values for this machine
```

## Structure

```
dot_config/           -> ~/.config/
  helix/              -> helix editor
  kanata/             -> keyboard remapping (Colemak, home-row mods)
  kitty/              -> terminal emulator
  nvim/               -> LazyVim config
  yazi/               -> terminal file manager
  zed/                -> Zed editor
  zellij/             -> terminal multiplexer (Ctrl-g leader, locked default)
dot_bashrc            -> ~/.bashrc
dot_bash_profile      -> ~/.bash_profile
dot_zshrc.tmpl        -> ~/.zshrc (templated per machine)
dot_zshenv            -> ~/.zshenv
dot_vimrc             -> ~/.vimrc
dot_p10k.zsh          -> ~/.p10k.zsh (Powerlevel10k prompt)
run_once_before_*     -> bootstrap scripts (run once per machine)
nixos/                -> reference configs (NOT managed by chezmoi)
docs/                 -> examples and originals
```

## Daily Commands

```bash
chezmoi diff          # preview changes
chezmoi apply         # apply changes to home dir
chezmoi cd            # cd to source dir
chezmoi edit ~/.zshrc # edit source file
chezmoi re-add        # re-add changed target files back to source
```

## Managed Tools

| Tool      | Purpose                    |
|-----------|----------------------------|
| zsh       | Shell (vi mode, zoxide, atuin, fzf) |
| nvim      | LazyVim editor             |
| kitty     | GPU terminal emulator      |
| zellij    | Terminal multiplexer       |
| yazi      | Terminal file manager      |
| kanata    | Colemak + home-row mods    |
| helix     | Helix editor               |
| zed       | Zed editor                 |
| p10k      | Powerlevel10k zsh prompt   |

## Migration Notes

Migrated from symlink-based setup.sh to chezmoi on 2026-05-06.
Old setup.sh is kept for reference but no longer used.
