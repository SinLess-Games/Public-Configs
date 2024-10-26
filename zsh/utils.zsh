# [<level] | <message>
# 0: INFO - Blue with info emoji
# 1: WARN - Yellow with warning emoji
# 2: ERROR - bold bright Red with error emoji
# message should return to white

function log_info() {
    local msg="$1"
    echo -e "\e[34mℹ️  INFO: \e[0m$msg"
}

function log_warn() {
    local msg="$1"
    echo -e "\e[33m⚠️  WARN: \e[0m$msg"
}

function log_error() {
    local msg="$1"
    echo -e "\e[1;31m❌ ERROR: \e[0m$msg"
}

# ------------------------------------------------------------------------------
# Section configure environment
# ------------------------------------------------------------------------------
# Set the default editor to nano
export EDITOR="nano"

# activate ssh agent and install it if it doesn't exist
if [ -z "$SSH_AUTH_SOCK" ]; then
    log_info $(eval "$(ssh-agent -s)")
fi

# add local and usr bin to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# zsh completion
autoload -Uz compinit
compinit

# ZSH environment variables
export ZSH="/home/sinless/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"


HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000