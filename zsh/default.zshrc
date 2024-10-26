# ~/.zshrc - Default Zsh Configuration with Simple Theme

# -------------------------------------------------------------------
# General Settings
# -------------------------------------------------------------------

# Set history file location and history options
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

# Set default editor
export EDITOR="nano"

# Enable command auto-correction
setopt CORRECT

# Enable globbing (for extended pattern matching)
setopt EXTENDED_GLOB

# Case-insensitive globbing and completion
setopt NO_CASE_GLOB
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable sharing history between sessions
setopt SHARE_HISTORY

# -------------------------------------------------------------------
# Theme and Prompt
# -------------------------------------------------------------------

# Define colors for the theme
autoload -U colors && colors
PROMPT_COLOR="%F{cyan}"
DIR_COLOR="%F{green}"
BRACKET_COLOR="%F{blue}"
RESET_COLOR="%f"

# Simple theme with user, host, and current directory
PROMPT="${BRACKET_COLOR}[${PROMPT_COLOR}%n${BRACKET_COLOR}@${PROMPT_COLOR}%m ${DIR_COLOR}%~${BRACKET_COLOR}]${RESET_COLOR} → "

# Right prompt shows exit code if non-zero
RPROMPT='%F{red}%?%f'

# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------

# Common commands
alias ll="ls -lah"                # Detailed list view
alias la="ls -A"                  # List all files including hidden ones
alias l="ls -CF"                  # Compact list view
alias grep="grep --color=auto"    # Grep with color output

# System update shortcuts
alias update="sudo apt update && sudo apt upgrade -y"

alias initenv="curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/.zshrc && source ~/.zshrc"

# Change to commonly used directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# -------------------------------------------------------------------
# Path and Environment
# -------------------------------------------------------------------

# Add custom paths (modify according to your environment)
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Python virtual environment prompt support
if [[ -n "$VIRTUAL_ENV" ]]; then
    PROMPT="(${VIRTUAL_ENV:t}) $PROMPT"
fi

# -------------------------------------------------------------------
# Plugins and Completions
# -------------------------------------------------------------------

# Load completions
autoload -Uz compinit
compinit

# Load history search if available
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# -------------------------------------------------------------------
# Optional Functions
# -------------------------------------------------------------------

# Define a function to quickly reload the .zshrc
function reload_zshrc() {
    source "$HOME/.zshrc"
    echo "Zsh configuration reloaded!"
}

# -------------------------------------------------------------------
# End of Configuration
# -------------------------------------------------------------------

# Print a welcome message
echo "${PROMPT_COLOR}Welcome to Zsh with Simple Theme!${RESET_COLOR}"
