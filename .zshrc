# Check if running in Zsh; if not, install and switch to Zsh
if [ -z "$ZSH_VERSION" ]; then
  echo "You are not running Zsh. Setting up Zsh..."

  # Install Zsh if not installed
  if ! command -v zsh &>/dev/null; then
    echo "Zsh not found. Installing Zsh..."
    sudo apt update && sudo apt install -y zsh
  fi

  # Set Zsh as the default shell
  chsh -s "$(which zsh)"

  # Relaunch Zsh to apply changes
  exec zsh
  return
fi

# -------------------------------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -------------------------------------------------------------------------------------------------------------
#                               Script Overview
#
# This script installs and configures a secure, consistent Zsh environment for development.
# -------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------------
# Section 0: Homebrew Non-Interactive Installation
# -------------------------------------------------------------------------------------------------------------

# Temporarily disable interactive prompts
export HOMEBREW_NO_INTERACTIVE=1

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew in non-interactive mode..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Re-enable interactive prompts
unset HOMEBREW_NO_INTERACTIVE

# Set Homebrew in the environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# -------------------------------------------------------------------------------------------------------------
# Section 1: ASCII Art and Environment Setup
# -------------------------------------------------------------------------------------------------------------

# ASCII Art Installation
if ! command -v figlet &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y figlet
fi

ascii_art() {
    local input_string="$1"
    if [ -z "$input_string" ]; then
        echo "[ERROR] | No input provided. Usage: ascii_art <string>"
        return 1
    fi

    local art_color="\e[1;33m"       # Yellow for ASCII art
    local border_color="\e[1;34m"    # Blue for border
    local fill_color="\e[1;37m"      # White for the fill pattern (dots)
    local reset="\e[0m"
    local terminal_width=$(tput cols)
    local border_width=2
    local art_width=$((terminal_width - border_width * 2))

    local ascii_output=$(figlet -w "$art_width" -f slant "$input_string")

    echo -e "${border_color}$(printf '#%.0s' $(seq 1 $terminal_width))"
    while IFS= read -r line; do
        local padding=$(( (art_width - ${#line}) / 2 ))
        printf "${border_color}##${fill_color}%*s${art_color}%s${fill_color}%*s${border_color}##${reset}\n" \
            "$padding" "" "$line" "$padding" ""
    done <<< "$ascii_output"
    echo -e "${border_color}$(printf '#%.0s' $(seq 1 $terminal_width))${reset}"
}

# Generate ASCII Art
clear
ascii_art "SinLess Games LLC Development Packet."

# -------------------------------------------------------------------------------------------------------------
# Section 2: Environment Setup
# -------------------------------------------------------------------------------------------------------------

export SHELL=/bin/zsh

# Define Oh My Zsh paths
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Update PATH for other programs
export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH:/usr/local/bin:$HOME/go/bin:$PATH"

# Enable command history and autocomplete
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
autoload -Uz compinit && compinit

# Alias for reloading .zshrc
alias reload="source ~/.zshrc"

# -------------------------------------------------------------------------------------------------------------
# Section 3: Installing Oh My Zsh and Powerlevel10k if not present
# -------------------------------------------------------------------------------------------------------------

# Ensure Zsh is installed
if ! command -v zsh &>/dev/null; then
  sudo apt update && sudo apt install -y zsh
  chsh -s "$(which zsh)"
fi

# Install Oh My Zsh if not installed
if [ ! -d "$ZSH" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme if not present
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Install Zsh plugins if not present
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    git clone https://github.com/zsh-users/$plugin "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# -------------------------------------------------------------------------------------------------------------
# Section 4: Fonts Installation (Linux-only workaround)
# -------------------------------------------------------------------------------------------------------------

# Skip Homebrew Cask fonts installation if on Linux, as it's macOS-specific
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    brew tap homebrew/cask-fonts
    for font in font-awesome font-hack-nerd-font; do
        brew install --cask "$font"
    done
fi

# -------------------------------------------------------------------------------------------------------------
# Section 5: Aliases
# -------------------------------------------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lh"
alias la="ls -a"
alias cls="clear"

# -------------------------------------------------------------------------------------------------------------
# Section 6: Final Source and Prompt
# -------------------------------------------------------------------------------------------------------------

# Source Zsh and plugins
source "$ZSH/oh-my-zsh.sh"
source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Powerlevel10k instant prompt
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Apply the Powerlevel10k theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
