# -----------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------
# Homebrew Installation (Non-interactive mode)
# -----------------------------------------------------------------------------------------
# This section installs Homebrew in non-interactive mode if it is not already installed.
# Homebrew is used to install various command-line tools that are required by the configuration.
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "NON_INTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
  /bin/bash -c "NON_INTERACTIVE=0"
  echo "Homebrew installed successfully."
  clear
fi

# -----------------------------------------------------------------------------------------
# Variables and Configuration
# -----------------------------------------------------------------------------------------
# This section contains environment variables, color codes for logging, and Zsh options.
# These variables and settings help configure and standardize the terminal experience.
LOG_INFO='\033[1;34m[INFO]\033[0m'
LOG_WARN='\033[1;33m[WARN]\033[0m'
LOG_ERROR='\033[1;31m[ERROR]\033[0m'

export SHELL=/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export PATH="$HOME/.local/share/gem/ruby/3.1.0/bin:$HOME/go/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PIPENV_VENV_IN_PROJECT=true

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
autoload -Uz compinit && compinit

# -----------------------------------------------------------------------------------------
# Section 1: ASCII Art
# -----------------------------------------------------------------------------------------
# Installs Figlet if it's not present and defines a function called `bordered_ascii` to display
# ASCII art text with a blue border.
if ! command -v figlet &>/dev/null; then
  echo -e "${LOG_INFO} Installing Figlet..."
  brew install figlet >/dev/null 2>&1
fi

function bordered_ascii() {
  if [ -z "$1" ]; then
    echo -e "${LOG_ERROR} Usage: bordered_ascii <text>"
    return 1
  fi

  # ANSI color codes
  BLUE='\033[1;34m'
  GOLD='\033[1;33m'
  RESET='\033[0m'

  # Get terminal width
  term_width=$(tput cols)
  
  # Generate the ASCII art using figlet, fitting it within the terminal width
  ascii_art=$(figlet -w "$term_width" "$1")
  
  # Determine the length of the longest line in the ASCII art
  max_length=$(echo "$ascii_art" | awk '{ if (length > max) max = length } END { print max }')
  
  # Calculate total width for padding (including two spaces on each side)
  padded_length=$((max_length + 4))

  # Generate the top and bottom border using ##
  border=$(printf "%-${padded_length}s" "" | tr ' ' '#')
  border="${BLUE}##${border}##${RESET}"

  # Print the bordered ASCII art with padding
  echo -e "$border"
  echo -e "${BLUE}##${RESET}$(printf "%-${padded_length}s" "")${BLUE}##${RESET}"
  echo "$ascii_art" | while IFS= read -r line; do
    printf "${BLUE}##${RESET}  ${GOLD}%-${max_length}s${RESET}  ${BLUE}##${RESET}\n" "$line"
  done
  echo -e "${BLUE}##${RESET}$(printf "%-${padded_length}s" "")${BLUE}##${RESET}"
  echo -e "$border"
}

# -----------------------------------------------------------------------------------------
# Section 2: Log Functions
# -----------------------------------------------------------------------------------------
# Defines logging functions for information, warnings, and errors.
function log_info() {
  echo -e "${LOG_INFO} $1"
}

function log_warn() {
  echo -e "${LOG_WARN} $1"
}

function log_error() {
  echo -e "${LOG_ERROR} $1"
}

# -----------------------------------------------------------------------------------------
# Section 3: Installing Zsh, Oh My Zsh, and Plugins
# -----------------------------------------------------------------------------------------
# Installs Zsh, Oh My Zsh, Powerlevel10k theme, and several useful Zsh plugins if they are
# not already installed. Also downloads the Powerlevel10k configuration if it's not present.
if ! command -v zsh &>/dev/null; then
  log_info "Installing Zsh..."
  sudo apt install -y zsh 
  chsh -s $(which zsh)
fi

if [ ! -d "$ZSH" ]; then
  log_info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  log_info "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k >/dev/null 2>&1
fi

if [ ! -f ~/.p10k.zsh ]; then
  log_info "Downloading Powerlevel10k configuration file..."
  curl -L -o ~/.p10k.zsh https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.p10k.zsh >/dev/null 2>&1
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins_to_install=(
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"
  "zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search"
)

for plugin in "${plugins_to_install[@]}"; do
  name=$(echo $plugin | cut -d' ' -f1)
  repo=$(echo $plugin | cut -d' ' -f2)
  if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
    log_info "Installing $name plugin..."
    git clone $repo $ZSH_CUSTOM/plugins/$name >/dev/null 2>&1
  fi
done

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fzf
  docker-compose
  npm
  pip
  ssh-agent
  aliases
  vscode
  ufw
  terraform
  systemd
  systemadmin
  sudo
  ssh
  python
  pylint
  pyenv
  minikube
  kubectl
  kind
  istioctl
  git-flow
  git-extras
  gh
  ansible
  aws
  docker
  fluxcd
  helm
  istioctl
)

# -----------------------------------------------------------------------------------------
# Section 4: Installing Fonts and Other Tools
# -----------------------------------------------------------------------------------------
# Installs required fonts using Homebrew or downloads them manually if Homebrew is unavailable.
if [ ! -d "$HOME/.fonts/fontawesome" ]; then
  if brew install --cask font-awesome >/dev/null 2>&1; then
    log_info "Font Awesome installed successfully."
  else
    log_warn "Could not install Font Awesome via Homebrew. Attempting manual installation..."
    wget https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-desktop.zip -O /tmp/fontawesome.zip >/dev/null 2>&1
    unzip /tmp/fontawesome.zip -d ~/.fonts/fontawesome && fc-cache -fv >/dev/null 2>&1
  fi
fi

if [ ! -d "$HOME/.fonts/hack-nerd-font" ]; then
  if brew install --cask font-hack-nerd-font >/dev/null 2>&1; then
    log_info "Hack Nerd Font installed successfully."
  else
    log_warn "Could not install Hack Nerd Font via Homebrew. Attempting manual installation..."
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O /tmp/hack-nerd-font.zip >/dev/null 2>&1
    unzip /tmp/hack-nerd-font.zip -d ~/.fonts/hack-nerd-font && fc-cache -fv >/dev/null 2>&1
  fi
fi

# -----------------------------------------------------------------------------------------
# Section 5: Install Apt Packages from YAML File
# -----------------------------------------------------------------------------------------
# This section installs packages specified in a YAML configuration file.
function install_apt_packages_from_yaml() {
    local yaml_file="~/.configs/SinlessGames/apt-packages.yaml"
    if [ -f "$yaml_file" ]; then
        local packages=$(yq e '.packages[]' "$yaml_file")
        log_info "Updating and upgrading apt packages..."
        sudo apt update >/dev/null 2>&1
        sudo apt upgrade -y >/dev/null 2>&1
        for package in $packages; do
            log_info "Installing $package..."
            sudo apt install -y "$package" >/dev/null 2>&1
        done
    else
        log_error "YAML file not found: $yaml_file"
    fi
}

# -----------------------------------------------------------------------------------------
# Section 6: Display Only Current Folder Name in the Prompt
# -----------------------------------------------------------------------------------------
# Configures the prompt to display only the current folder name.
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
POWERLEVEL9K_DIR_SHOW_WRITABLE=false
PROMPT_DIRTRIM=1

# -----------------------------------------------------------------------------------------
# Section 7: Aliases
# -----------------------------------------------------------------------------------------
# Defines various aliases to simplify terminal commands.
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias ll="ls -alFh" 
alias la="ls -A"
alias l="ls -CF"
alias cls="clear"
alias cll="clear && ll"

# -----------------------------------------------------------------------------------------
# Section 8: Show Virtual Environment Information in the Prompt
# -----------------------------------------------------------------------------------------
# This section updates the prompt to show active Python virtual environments.
function update_prompt_with_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    VENV_NAME=$(basename "$VIRTUAL_ENV")
    PS1="[($VENV_NAME)] $PS1"
  fi
}

if [[ -n "$VIRTUAL_ENV" ]]; then
  update_prompt_with_virtual_env
fi

# -----------------------------------------------------------------------------------------
# Section 9: Reload Zsh Configuration
# -----------------------------------------------------------------------------------------
# This function reloads the Zsh configuration by downloading the latest `.zshrc` and `.p10k.zsh` files.
function reload() {
  curl -L -o ~/.p10k.zsh https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.p10k.zsh > /dev/null 2>&1
  curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.zshrc > /dev/null 2>&1

  source ~/.zshrc
  log_info "Zsh configuration reloaded."
  sleep 4
  clear
}

# -----------------------------------------------------------------------------------------
# Section 10: Uninstall Package
# -----------------------------------------------------------------------------------------
# This function removes an installed package and updates the apt package list accordingly.
function uninstall() {
  read -p "Are you sure you want to uninstall $1? (y/N) " -n 1 -r

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo apt remove -y $1
    yq d -i .configs/apt-packages.yaml "packages[==\"$1\"]"
    install_apt_packages_from_yaml
  else
    echo "Uninstall cancelled"
  fi
}

# -----------------------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------------------
# Main execution to display ASCII art, log the Zsh setup, and install packages.
bordered_ascii "SinLess Games LLC"
log_info "Setting up Zsh development environment..."
source $ZSH/oh-my-zsh.sh
precmd_functions+=update_prompt_with_virtual_env
install_apt_packages_from_yaml
