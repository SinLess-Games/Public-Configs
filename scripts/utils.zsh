# -------------------------------------------------------------------------------------------------------------
# Utility Functions and Plugin Setup for Zsh
# -------------------------------------------------------------------------------------------------------------

# Color Codes
COLOR_INFO="\e[1;34m"        # Blue
COLOR_WARN="\e[1;33m"        # Orange/Yellow
COLOR_ERROR="\e[1;91m\e[1m"  # Bright Red and Bold
RESET_COLOR="\e[0m"

# Logging Functions
log_info() {
  echo -e "${COLOR_INFO}[INFO] $1${RESET_COLOR}"
}

log_warn() {
  echo -e "${COLOR_WARN}[WARN] $1${RESET_COLOR}"
}

log_error() {
  echo -e "${COLOR_ERROR}[ERROR] $1${RESET_COLOR}"
}

# Non-Interactive Homebrew Installation
export HOMEBREW_NO_INTERACTIVE=1
if ! command -v brew &>/dev/null; then
  log_info "Installing Homebrew in non-interactive mode..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
unset HOMEBREW_NO_INTERACTIVE
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# ASCII Art Function
if ! command -v figlet &>/dev/null; then
  log_info "Installing figlet for ASCII art..."
  sudo apt-get update && sudo apt-get install -y figlet
fi

ascii_art() {
  local input_string="$1"
  if [ -z "$input_string" ]; then
    log_error "No input provided. Usage: ascii_art <string>"
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

# Plugin Installation
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export zsh-users-plugins=(
  zsh-autocomplete
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
  zsh-history-substring-search
  zsh-interactive-cd
  zsh-navigation-tools
)

for plugin in "${zsh-users-plugins[@]}"; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    log_info "Installing $plugin plugin..."
    git clone "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# Font Installation (Linux only)
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  brew tap homebrew/cask-fonts
  for font in font-awesome font-hack-nerd-font; do
    brew install --cask "$font"
  done
fi
