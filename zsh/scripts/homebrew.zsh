# ----------------------------------------------------------------------
# Homebrew
# ----------------------------------------------------------------------
# Install homebre if it does not exist
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# configure zsh completions
log_info "Configuring homebrew completions"
if [ -f "/opt/homebrew/share/zsh/site-functions/_brew" ]; then
    fpath+=("/opt/homebrew/share/zsh/site-functions")
fi

# Configure Homebrew in the shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update Homebrew
log_info "Updating Homebrew"
brew update

# install brew packages if Brefile exists
if [ -f "$HOME/Brewfile" ]; then
    log_info "Installing brew packages from Brewfile"
    brew bundle --file="$HOME/Brewfile"
fi