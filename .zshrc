# -------------------------------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -------------------------------------------------------------------------------------------------------------
#                               What this script installs and does
#
# -------------------------------------------------------------------------------------------------------------
# Section 1: ASCII Art and Environment Setup
# -------------------------------------------------------------------------------------------------------------
# Generates ASCII art and sets up environment variables, paths, history, and autocomplete.      

# ASCII Art Function
sudo apt-get install -y figlet

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

    echo -e "${border_color}"
    for ((i = 0; i < terminal_width; i++)); do
        echo -n "#"
    done
    echo

    while IFS= read -r line; do
        local line_length=${#line}
        local space_padding=$(( (art_width - line_length) / 2 ))
        local right_padding=$((art_width - line_length - space_padding))

        echo -en "${border_color}##${fill_color}"
        printf '%*s' "$space_padding" | tr ' ' '.'
        echo -en "${art_color}"
        for ((i=0; i<${#line}; i++)); do
            char="${line:$i:1}"
            if [[ "$char" == " " ]]; then
                echo -en "${fill_color}."
            else
                echo -en "${art_color}${char}"
            fi
        done
        echo -en "${fill_color}"
        printf '%*s' "$right_padding" | tr ' ' '.'
        echo -en "${border_color}##${reset}"
        echo
    done <<< "$ascii_output"

    echo -en "${border_color}"
    for ((i = 0; i < terminal_width; i++)); do
        echo -n "#"
    done
    echo -e "${reset}"
}

# Generate ASCII Art
clear
ascii_art "SinLess Games LLC Development Packet."


# -------------------------------------------------------------------------------------------------------------
# Section 2: Environment Setup
# -------------------------------------------------------------------------------------------------------------

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Set Zsh as the default shell
export SHELL=/bin/zsh

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Add Ruby to the PATH for colorls
export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$PATH"

# Add local bin to the PATH
export PATH="$PATH:/usr/local/bin"

# Add Go to the PATH
export PATH="$HOME/go/bin:$PATH"

# Enable command history and autocomplete
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
autoload -Uz compinit && compinit

# Set the alias for reloading the .zshrc file
alias reload="source ~/.zshrc"

# -------------------------------------------------------------------------------------------------------------
# Section 3: Installing Oh My Zsh and Powerlevel10k if not present
# -------------------------------------------------------------------------------------------------------------

# Install Zsh if not installed
if ! command -v zsh &>/dev/null; then
  sudo apt install -y zsh
  chsh -s $(which zsh)
fi

# Install Oh My Zsh if not installed
if [ ! -d "$ZSH" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k if not installed
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install Zsh Autosuggestions and Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# -------------------------------------------------------------------------------------------------------------
# Section 4: Installing Fonts and Other Tools
# -------------------------------------------------------------------------------------------------------------

# Install Font Awesome and Nerd Fonts
brew tap homebrew/cask-fonts
brew install --cask font-awesome
brew install --cask font-hack-nerd-font

# Install additional packages via a function
function install_apt_packages() {
    local packages=("$@")
    sudo apt update
    for package in "${packages[@]}"; do
        sudo apt install -y "$package"
    done
}

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

# Source Zsh plugins
source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Apply the Powerlevel10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh