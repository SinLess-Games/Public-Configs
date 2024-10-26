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

# Check if utils.zsh exists, if not, download it from the repo
if [ ! -f "$HOME/.zsh/utils.zsh" ]; then
    echo "utils.zsh not found. Downloading from the repository..."
    curl -o "$HOME/.zsh/utils.zsh" "https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/utils.zsh"
    echo "utils.zsh downloaded successfully!"
fi

# Source utils.zsh to access log functions
source "$HOME/.zsh/utils.zsh"

# ---------------------------------------------------------------------------
# Section 1: Download the scripts folder and load scripts
# ---------------------------------------------------------------------------

# Check if the scripts folder exists
if [ ! -d "$HOME/.zsh/scripts" ]; then
    log_info "Scripts folder not found. Downloading from the repository..."

    # Create the scripts folder
    mkdir -p "$HOME/.zsh/scripts"

    # Base URL for the GitHub repo where scripts are located
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/scripts/"

    # List of scripts to download
    scripts=("anscii.zsh" "homebrew.zsh" "zsh-plugins.zsh")  # Add other script names here

    # Download each script from the GitHub repo
    for script in "${scripts[@]}"; do
        if curl -o "$HOME/.zsh/scripts/$script" "${base_url}${script}"; then
            log_info "$script downloaded successfully."
        else
            log_error "Failed to download $script."
        fi
    done

    log_info "All scripts downloaded successfully!"
else
    log_info "Scripts folder already exists. Skipping download."
fi

# ---------------------------------------------------------------------------
# Section 2: Source the scripts
# ---------------------------------------------------------------------------

# Source each script in the scripts folder
for script in "$HOME/.zsh/scripts/"*.zsh; do
    if [ -f "$script" ]; then
        source "$script"
        log_info "Loaded $script"
    else
        log_warn "No script found in $script."
    fi
done
