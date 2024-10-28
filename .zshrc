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

# Reset PATH to a minimal set for testing
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"


# -------------------------------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -------------------------------------------------------------------------------------------------------------
# Overview: This script configures a secure, consistent Zsh environment for development.
# -------------------------------------------------------------------------------------------------------------

# Ensure scripts directory exists
mkdir -p "$HOME/scripts"

# Add Homebrew to PATH if installed
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# Load ASCII art banner
clear
ascii_art "SinLess Games LLC"

plugin=(
    ansible
    arduino-cli
    autopep8
    azure
    brew
    colorize
    colored-man-pages
    cp
    docker
    docker-compose
    fluxcd
    gcloud
    gem
    gh
    git
    git-auto-fetch
    git-commit
    git-extras
    git-flow
    gitignore
    git-lfs
    golang
    gpg-agent
    helm
    heroku
    history
    history-substring-search
    istioctl
    kind
    kops
    kubectl
    kubectx
    microk8s
    minikube
    mongo-atlas
    mongocli
    ng
    nmap
    node
    nodenv
    npm
    pep8
    pip
    poetry
    poetry-env
    postgres
    pre-commit
    pylint
    python
    react-native
    redis-cli
    screen
    ssh
    ssh-agent
    sudo
    terraform
    ubuntu
    urltools
    virtualenv
    zsh-interactive-cd
    zsh-autocomplete
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-interactive-cd
    zsh-navigation-tools
)

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
autoload -Uz compinit vcs_info
compinit

# Reload alias
alias reload="source ~/.zshrc"

# Install or Update utility and prompt scripts if missing
if [ ! -f "$HOME/scripts/utils.zsh" ]; then
  echo "[INFO] Downloading utility functions..."
  curl -sL https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/scripts/utils.zsh -o "$HOME/scripts/utils.zsh"
fi

if [ ! -f "$HOME/scripts/prompt-mod.zsh" ]; then
  echo "[INFO] Downloading prompt modification script..."
  curl -sL https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/scripts/prompt-mod.zsh -o "$HOME/scripts/prompt-mod.zsh"
fi

# Source utility functions and prompt configuration
source "$HOME/scripts/utils.zsh"
source "$HOME/scripts/prompt-mod.zsh"

# Plugin activation and theme
source "$ZSH/oh-my-zsh.sh"
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Final Zsh options and key bindings
export EDITOR=nano
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

autoload -Uz compinit
compinit -C
export skip_global_compinit=1
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
export POWERLEVEL9K_INSTANT_PROMPT=off

# Key bindings
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

alias remove_scripts="rm -rf $HOME/scripts"

# Start SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

ssh-add ~/.ssh/sinless777_ecdsa.pub

