# ------------------------------------------------------------------------------
# This script downloads and sources other scripts that are located in the
# scripts folder. This is useful for keeping the main .zshrc file clean and
# organized. The script will download the scripts folder from the GitHub
# repository and source all scripts in the folder.
#
# Usage:
#   1. Add this script to the .zshrc file.
#   2. Define the base URL for the GitHub repo where scripts are located.
#   3. List the names of the scripts to download.
#   4. Run the script to download and source the scripts.
#
# Note: Make sure to update the base URL and script names as needed.
# ------------------------------------------------------------------------------

# check if utils.zsh exists if not install it from repo
if [ ! -f "$HOME/.zsh/utils.zsh" ]; then
    log_info "utils.zsh not found. Downloading from the repository..."
    curl -o "$HOME/.zsh/utils.zsh" "https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/utils.zsh"
    echo "utils.zsh downloaded successfully!"

    source "$HOME/.zsh/utils.zsh"
fi

# ------------------------------------------------------------------------------
# Section 1: download the scripts folder and load scripts
# ------------------------------------------------------------------------------
# check if the scripts folder exists
if [ ! -d "$HOME/.zsh/scripts" ]; then
    log_info "Scripts folder not found. Downloading from the repository..."

    # Create the scripts folder
    mkdir -p "$HOME/.zsh/scripts"

    # Base URL for the GitHub repo where scripts are located
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/scripts/"

    # List of scripts to download
    scripts=("anscii.zsh" "homebrew.zsh", "zsh-plugins.zsh")  # Add other script names here

    # Download each script from the GitHub repo
    for script in "${scripts[@]}"; do
        curl -o "$HOME/.zsh/scripts/$script" "${base_url}${script}"
    done

    log_info "Scripts downloaded successfully!"
fi

# ------------------------------------------------------------------------------
# Section 2: source the scripts
# ------------------------------------------------------------------------------
# Source all scripts in the scripts folder
for script in "$HOME/.zsh/scripts/"*.zsh; do
    if [ -f "$script" ]; then
        source "$script"
        log_info "Loaded $script"
    fi
done
