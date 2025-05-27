# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k theme
source ~/github-codes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# vi style shortcut
set -o vi

# Alias by user
alias ll='ls -la'
alias llh='ls -lah'
# alias vz='vim ~/.zshrc'
# alias sz='source ~/.zshrc'
alias sdi='sudo dnf install'
# alias sdu='sudo dnf update'
alias aau='sudo dnf update -y && sudo npm update'
# alias blsadd='sudo blsctl cmdline all set i915.enable_psr=0'
# alias ra='joshuto'
alias ze='zellij'
alias lg='lazygit'

# History confirmations
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory # immediately append to the history file

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# atuin
eval "$(atuin init zsh)"

# yazi wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# shell autocompletion for uv commands
# eval "$(uv generate-shell-completion zsh)"
# eval "$(uvx --generate-shell-completion zsh)"

# zoxide
eval "$(zoxide init zsh)"
