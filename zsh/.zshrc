# -----------------------------------------------------------------------------------------
# Zsh Configuration Script
# Author: Tim Pierce
# Company: SinLess Games LLC   https://sinlessgamesllc.com
# License: MIT
# -----------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------
# Homebrew Installation (Non-interactive mode)
# -----------------------------------------------------------------------------------------
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

# Define required apt packages
REQUIRED_APT_PACKAGES=(
  zsh
  curl
  figlet
  yq
)

# -----------------------------------------------------------------------------------------
# Section 1: Install Required APT Packages
# -----------------------------------------------------------------------------------------
for package in "${REQUIRED_APT_PACKAGES[@]}"; do
  if ! dpkg -l | grep -q "$package"; then
    echo -e "${LOG_INFO} Installing $package..."
    sudo apt install -y "$package" >/dev/null 2>&1
  fi
done

# -----------------------------------------------------------------------------------------
# Section 2: ASCII Art
# -----------------------------------------------------------------------------------------
function bordered_ascii() {
  if [ -z "$1" ]; then
    echo -e "${LOG_ERROR} Usage: bordered_ascii <text>"
    return 1
  fi

  # ANSI color codes
  BLUE='\033[1;34m'
  GOLD='\033[1;33m'
  RESET='\033[0m'

  term_width=$(tput cols)
  ascii_art=$(figlet -w "$term_width" "$1")
  max_length=$(echo "$ascii_art" | awk '{ if (length > max) max = length } END { print max }')
  padded_length=$((max_length + 4))

  border=$(printf "%-${padded_length}s" "" | tr ' ' '#')
  border="${BLUE}##${border}##${RESET}"

  echo -e "$border"
  echo -e "${BLUE}##${RESET}$(printf "%-${padded_length}s" "")${BLUE}##${RESET}"
  echo "$ascii_art" | while IFS= read -r line; do
    printf "${BLUE}##${RESET}  ${GOLD}%-${max_length}s${RESET}  ${BLUE}##${RESET}\n" "$line"
  done
  echo -e "${BLUE}##${RESET}$(printf "%-${padded_length}s" "")${BLUE}##${RESET}"
  echo -e "$border"
}

# -----------------------------------------------------------------------------------------
# Section 3: Progress Bar Function
# -----------------------------------------------------------------------------------------
function display_progress_bar() {
  echo -e "${LOG_INFO} Configuring the environment. This may take a few minutes..."
  bar=""

  # Progress bar loop
  for i in {1..50}; do
    bar+="#"
    printf "\r[%-50s] %d%%" "$bar" $((i * 2))
    sleep 0.1
  done

  echo -e "\n${LOG_INFO} Environment configuration complete."
}

# -----------------------------------------------------------------------------------------
# Section 4: Log Functions
# -----------------------------------------------------------------------------------------
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
# Section 5: Installing Oh My Zsh, Powerlevel10k, and Plugins
# -----------------------------------------------------------------------------------------
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
# Section 6: Installing Fonts and Other Tools
# -----------------------------------------------------------------------------------------
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
# Section 7: Install Apt Packages from YAML File
# -----------------------------------------------------------------------------------------
function install_apt_packages_from_yaml() {
    local yaml_file="./.configs/apt-packages.yaml"
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
# Section 8: Install Brewfile Packages
# -----------------------------------------------------------------------------------------
BREWFILE_PATH="./Brewfile"
if [ -f "$BREWFILE_PATH" ]; then
  log_info "Brewfile found. Installing Brewfile packages..."
  brew bundle --file="$BREWFILE_PATH" >/dev/null 2>&1
  log_info "Brewfile packages installed."
fi

# -----------------------------------------------------------------------------------------
# Section 9: Pipenv Installation and Virtual Environment Setup
# -----------------------------------------------------------------------------------------
PIPFILE_PATH="./Pipfile"
if [ -f "$PIPFILE_PATH" ]; then
  if ! command -v pipx &>/dev/null; then
    log_info "Installing pipx..."
    brew install pipx >/dev/null 2>&1
    log_info "pipx installed."
  fi

  if ! command -v pipenv &>/dev/null; then
    log_info "Installing pipenv via pipx..."
    pipx install pipenv >/dev/null 2>&1
  fi

  if [ ! -d ".venv" ]; then
    log_info "Creating virtual environment using Pipenv with Python 3.13..."
    pipenv --python 3.13 >/dev/null 2>&1
    log_info "Installing dependencies from Pipfile..."
    pipenv install >/dev/null 2>&1
  else
    log_info "Activating existing virtual environment..."
    pipenv shell
  fi
fi

# -----------------------------------------------------------------------------------------
# Section 10: Configuring Prompt to Show Current Folder Name
# -----------------------------------------------------------------------------------------
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
POWERLEVEL9K_DIR_SHOW_WRITABLE=false
PROMPT_DIRTRIM=1

# -----------------------------------------------------------------------------------------
# Section 11: Aliases
# -----------------------------------------------------------------------------------------
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
# Section 12: Show Virtual Environment Information in the Prompt
# -----------------------------------------------------------------------------------------
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
# Section 13: Reload Zsh Configuration
# -----------------------------------------------------------------------------------------
function reload() {
  curl -L -o ~/.p10k.zsh https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.p10k.zsh > /dev/null 2>&1
  curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.zshrc > /dev/null 2>&1
  source ~/.zshrc
  log_info "Zsh configuration reloaded."
  sleep 4
  clear
}

# -----------------------------------------------------------------------------------------
# Section 14: Uninstall and Revert to Default Zsh Configuration
# -----------------------------------------------------------------------------------------
function uninstall() {
  read -p "Are you sure you want to uninstall all traces of the custom Zsh configuration? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Removing custom Zsh configuration..."

    # Remove oh-my-zsh and related themes/plugins
    rm -rf ~/.oh-my-zsh
    rm -rf ~/.p10k.zsh

    # Reset to default Zsh configuration
    log_info "Restoring default Zsh configuration..."
    curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/default.zshrc > /dev/null 2>&1
    source ~/.zshrc

    # Remove installed apt packages
    for package in "${REQUIRED_APT_PACKAGES[@]}"; do
      log_info "Uninstalling $package..."
      sudo apt purge -y $package >/dev/null 2>&1
    done
    sudo apt autoremove -y >/dev/null 2>&1

    log_info "Uninstallation complete. Default Zsh configuration restored."
  else
    log_info "Uninstall cancelled."
  fi
}

# -----------------------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------------------
bordered_ascii "SinLess Games LLC"
display_progress_bar
log_info "Setting up Zsh development environment..."
source $ZSH/oh-my-zsh.sh
precmd_functions+=update_prompt_with_virtual_env
install_apt_packages_from_yaml
