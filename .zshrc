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

export HOMEBREW_NO_INTERACTIVE=1

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "[INFO] Installing Homebrew in non-interactive mode..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

unset HOMEBREW_NO_INTERACTIVE

# Set Homebrew in the environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# -------------------------------------------------------------------------------------------------------------
# Section 1: ASCII Art and Environment Setup
# -------------------------------------------------------------------------------------------------------------

if ! command -v figlet &>/dev/null; then
  echo "[INFO] Installing figlet for ASCII art..."
  sudo apt-get update && sudo apt-get install -y figlet
fi

ascii_art() {
  local input_string="$1"
  if [ -z "$input_string" ]; then
    echo "[ERROR] No input provided. Usage: ascii_art <string>"
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
    local right_padding=$((art_width - ${#line} - padding))
    printf "${border_color}##${fill_color}%*s${art_color}%s${fill_color}%*s${border_color}##${reset}\n" \
      "$padding" "" "$line" "$right_padding" ""
  done <<< "$ascii_output"
  echo -e "${border_color}$(printf '#%.0s' $(seq 1 $terminal_width))${reset}"
}

clear
ascii_art "SinLess Games LLC"

# -------------------------------------------------------------------------------------------------------------
# Section 2: Environment Setup
# -------------------------------------------------------------------------------------------------------------

export SHELL=/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH:/usr/local/bin:$HOME/go/bin:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
autoload -Uz compinit && compinit

alias reload="source ~/.zshrc"

# -------------------------------------------------------------------------------------------------------------
# Section 3: Installing Oh My Zsh and Powerlevel10k if not present
# -------------------------------------------------------------------------------------------------------------

if ! command -v zsh &>/dev/null; then
  echo "[INFO] Installing Zsh..."
  sudo apt update && sudo apt install -y zsh
  chsh -s "$(which zsh)"
fi

if [ ! -d "$ZSH" ]; then
  echo "[INFO] Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "[INFO] Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo "[INFO] Installing $plugin..."
    git clone https://github.com/zsh-users/$plugin "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# -------------------------------------------------------------------------------------------------------------
# Section 4: Fonts Installation (Linux-only workaround)
# -------------------------------------------------------------------------------------------------------------

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

source "$ZSH/oh-my-zsh.sh"
source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -------------------------------------------------------------------------------------------------------------
# Section 7: Extra Changes
# -------------------------------------------------------------------------------------------------------------

zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

HISTSIZE=500
SAVEHIST=500
setopt hist_ignore_all_dups

export GITSTATUS_UPDATE_INTERVAL=5
export GITSTATUS_LOG_LEVEL=DEBUG

if [ -f ~/.zcompdump ]; then
  echo "[INFO] Removing outdated zcompdump files..."
  rm -f ~/.zcompdump*  # Forced removal without confirmation
fi
autoload -Uz compinit && compinit -C

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_INSTANT_PROMPT=off

PROMPT_DIRTRIM=1
PROMPT='%~ > '
