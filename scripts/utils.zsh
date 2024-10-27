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
  printf "${COLOR_INFO}[INFO] %s${RESET_COLOR}\n" "$1"
}

log_warn() {
  printf "${COLOR_WARN}[WARN] %s${RESET_COLOR}\n" "$1"
}

log_error() {
  printf "${COLOR_ERROR}[ERROR] %s${RESET_COLOR}\n" "$1"
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

  local ascii_output
  ascii_output=$(figlet -w "$art_width" -f slant "$input_string")

  printf "${border_color}%${terminal_width}s${reset}\n" | tr ' ' '#'
  while IFS= read -r line; do
    local padding=$(( (art_width - ${#line}) / 2 ))
    local right_padding=$((art_width - ${#line} - padding))
    printf "${border_color}##${fill_color}%*s${art_color}%s${fill_color}%*s${border_color}##${reset}\n" \
      "$padding" "" "$line" "$right_padding" ""
  done <<< "$ascii_output"
  printf "${border_color}%${terminal_width}s${reset}\n" | tr ' ' '#'
}

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
