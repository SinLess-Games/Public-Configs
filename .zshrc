# Check if running in Zsh; if not, install and switch to Zsh
if [ -z "$ZSH_VERSION" ]; then
  echo "[INFO] You are not running Zsh. Setting up Zsh..."
  
  # Install Zsh if not installed
  if ! command -v zsh &>/dev/null; then
    echo "[INFO] Zsh not found. Installing Zsh..."
    sudo apt update && sudo apt install -y zsh
  fi

  # Set Zsh as the default shell
  chsh -s "$(which zsh)"

  # Relaunch Zsh to apply changes
  exec zsh
fi

# -------------------------------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -------------------------------------------------------------------------------------------------------------
# Overview: This script configures a secure, consistent Zsh environment for development.
# -------------------------------------------------------------------------------------------------------------

if [ ! -f "$HOME/scripts/utils.zsh" ]; then
  echo "[ERROR] Required utility functions not found. Exiting..."
  curl -sL https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/scripts/utils.zsh -o "$HOME/scripts/utils.zsh"
fi

# Source utility functions and plugin setup
source "$HOME/scripts/utils.zsh"

# Environment variables and PATH
export SHELL=/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH:/usr/local/bin:$HOME/go/bin:$PATH"

# Zsh history and shell options
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
autoload -Uz compinit && compinit

# Reload alias
alias reload="source ~/.zshrc"

# Load ASCII art banner
clear
ascii_art "SinLess Games LLC"

# Plugin activation
source "$ZSH/oh-my-zsh.sh"
for plugin in "${plugins[@]}"; do
  if [ -f "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh" ]; then
    source "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh"
  fi
done

# Prompt and final sourcing
source "$ZSH/oh-my-zsh.sh"
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Final Zsh options and key bindings
export EDITOR=nano
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz vcs_info
precmd() { vcs_info }
HISTSIZE=500
SAVEHIST=500
setopt hist_ignore_all_dups
zstyle ':vcs_info:git:*' formats '%b '

autoload -Uz compinit && compinit -C
export skip_global_compinit=1
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
export POWERLEVEL9K_INSTANT_PROMPT=off

# Key bindings
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
