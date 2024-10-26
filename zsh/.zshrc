# ------------------------------------------------------------------------------
# This script downloads and sources other scripts located in the scripts folder.
# This keeps the main .zshrc file clean and organized by handling script downloads
# and sourcing in a modular way.
#
# Usage:
#   1. Add this script to the .zshrc file.
#   2. Define the base URL for the GitHub repo where scripts are located.
#   3. List the names of the scripts to download.
#   4. Run the script to download and source the scripts.
#
# Note: Make sure to update the base URL and script names as needed.
# ------------------------------------------------------------------------------

if [ -f "$HOME/.zsh/utils.zsh" ]; then
    source "$HOME/.zsh/utils.zsh"
else
    curl -o "$HOME/.zsh/utils.zsh" "https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/utils.zsh" >/dev/null 2>&1
    source "$HOME/.zsh/utils.zsh"
fi

# ------------------------------------------------------------------------------
# Section 1: Configure environment
# ------------------------------------------------------------------------------

# Set the default editor to nano
export EDITOR="nano"

# Activate SSH agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
    log_info "Starting SSH agent..."
    eval "$(ssh-agent -s)" >/dev/null
fi

# Add local and usr bin to path
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# Zsh completion
autoload -Uz compinit
compinit

# ZSH environment variables
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=100

# ------------------------------------------------------------------------------
# Main script
# ------------------------------------------------------------------------------
function main() {
    sudo apt-get install figlet -y > /dev/null 2>&1
    bordered_anscii "SinLess Games LLC"
    log_info "Starting the script. This may take a few moments..."

    # Define the steps for the progress bar
    local total_steps=4  # Update if more tasks are added
    local step=0

    # Progress Bar Helper
    function update_progress() {
        ((step++))
        progress_bar $((step * 100 / total_steps))
    }

    # Task 1: Install APT packages
    source "$HOME/.zsh/scripts/apt.zsh"
    setup_apt
    update_progress

    # Task 2: Install Oh My Zsh
    source "$HOME/.zsh/scripts/ohmyzsh.zsh"
    setup_ohmyzsh
    update_progress

    # Task 3: Download and install .p10k.zsh if not present
    if [ ! -f "$HOME/.p10k.zsh" ]; then
        log_info "Downloading .p10k.zsh configuration..."
        curl -o "$HOME/.p10k.zsh" "https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/.p10k.zsh"
        log_info ".p10k.zsh downloaded successfully."
    fi
    update_progress

    # Task 4: Set Powerlevel10k theme
    source "$HOME/.p10k.zsh"
    log_info "Powerlevel10k theme set."
    update_progress

    log_info "Setup complete!"
}

main