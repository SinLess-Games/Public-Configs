# ----------------------------------------------------------------------
# Homebrew Installation and Configuration
# ----------------------------------------------------------------------

# Install Homebrew if it is not already installed
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Configure Zsh completions for Homebrew
log_info "Configuring Homebrew completions..."
if [ -f "/opt/homebrew/share/zsh/site-functions/_brew" ]; then
    fpath+=("/opt/homebrew/share/zsh/site-functions")
fi

# Set up Homebrew environment in the current shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# Install packages from Brewfile if it exists
if [ -f "$HOME/Brewfile" ]; then
    log_info "Installing brew packages from Brewfile..."
    brew bundle --file="$HOME/Brewfile"
fi

# Refresh Homebrew environment variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Function to uninstall Homebrew
function uninstall_homebrew() {
    log_info "Uninstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}
