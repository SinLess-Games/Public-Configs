# [<level] | <message>
# 0: INFO - Blue with info emoji
# 1: WARN - Yellow with warning emoji
# 2: ERROR - bold bright Red with error emoji
# message should return to white

function log_info() {
    local msg="$1"
    echo -e "\e[34mℹ️  INFO: \e[0m$msg"
}

function log_warn() {
    local msg="$1"
    echo -e "\e[33m⚠️  WARN: \e[0m$msg"
}

function log_error() {
    local msg="$1"
    echo -e "\e[1;31m❌ ERROR: \e[0m$msg"
}


# ---------------------------------------------------------------------------
# Section 1: Download the scripts folder and load scripts
# ---------------------------------------------------------------------------

# Check if the scripts folder exists
if [ ! -d "$HOME/.zsh/scripts" ]; then
    log_info "Scripts folder not found. Downloading from the repository..."

    # Create the scripts folder
    mkdir -p "$HOME/.zsh/scripts"

    # Base URL for the GitHub repo where scripts are located
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/main/zsh/scripts/"

    # List of scripts to download
    scripts=("anscii.zsh" "homebrew.zsh" "zsh-plugins.zsh" "p10k.zsh" "ohmyzsh.zsh")  # Add other script names here

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
# Section 2: Download default configuration files
# ---------------------------------------------------------------------------

# Check if the configs folder exists
if [ ! -d "$HOME/.configs/SinlessGames" ]; then
    log_info "Configuration folder not found. Downloading from the repository..."

    # Create the configs folder
    mkdir -p "$HOME/.configs/SinlessGames"

    # Base URL for the GitHub repo where configs are located
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/main/configs/"

    # List of configuration files to download
    configs=("zsh-plugins.yaml" apt-packages.yaml)  # Add other config file names here

    # check if config file exists on hosts system and if not download it
    for config in "${configs[@]}"; do
        if [ ! -f "$HOME/.configs/SinlessGames/$config" ]; then
            if curl -o "$HOME/.configs/SinlessGames/$config" "${base_url}${config}"; then
                log_info "$config downloaded successfully."
            else
                log_error "Failed to download $config."
            fi
        else
            log_info "$config already exists. Skipping download."
        fi
    done

    log_info "All configuration files downloaded successfully!"
else
    log_info "Configuration folder already exists. Skipping download."
fi


# ---------------------------------------------------------------------------
# Section 3: Source the scripts
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

# ---------------------------------------------------------------------------
# Section 4: Progress bar
# ---------------------------------------------------------------------------

# progress_bar: Display a progress bar tracking the progress of a function
# Usage: progress_bar <total_steps> <current_step>
function progress_bar() {
    local total_steps="$1"
    local current_step="$2"
    local progress=$(( (current_step * 100) / total_steps ))
    local columns=$(tput cols)
    local bar_width=$(( columns - 20 ))
    local fill_width=$(( (bar_width * progress) / 100 ))
    local empty_width=$(( bar_width - fill_width ))
    
    # Render the bar with the current progress percentage
    printf "\rProgress: [%-${fill_width}s%${empty_width}s] %3d%%" \
           "$(printf "%${fill_width}s" | tr ' ' '▓')" \
           "$(printf "%${empty_width}s" | tr ' ' '░')" \
           "$progress"
}

# Function to complete the bar and move to a new line
function progress_complete() {
    printf "\n"
}

# ---------------------------------------------------------------------------
# Section 5: uninstall script
# ---------------------------------------------------------------------------

# uninstall: Uninstall the Zsh configuration and restore the original configuration
function uninstall() {
    # Ask user if they are sure they want to uninstall and warnthem that this will uninstall everything
    read -p "Are you sure you want to uninstall the Zsh configuration? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled."
        return
    fi

    log_info "Uninstalling the Zsh configuration..."

    # remove config files
    rm -rf "$HOME/.configs.SinlessGames"

    # remove the scripts folder
    rm -rf "$HOME/.zsh/scripts"

    # remove the .p10k.zsh file
    rm -f "$HOME/.p10k.zsh"

    # uninstall Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Uninstalling Oh My Zsh..."
        uninstall_ohmyzsh
    else
        log_info "Oh My Zsh not found. Skipping uninstall."
    fi

    # uninstall Homebrew
    if command -v brew &> /dev/null; then
        log_info "Uninstalling Homebrew..."
        uninstall_homebrew
    else
        log_info "Homebrew not found. Skipping uninstall."
    fi

    # remove utils.zsh
    rm -f "$HOME/.zsh/utils.zsh"

    log_info "Uninstall complete!"

    # replace the .zshrc file with the original
    if [ -f "$HOME/.zshrc.bak" ]; then
        mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
        log_info "Restored original .zshrc file."
    else
        log_warn "Backup .zshrc file not found. Manual intervention required."
    fi
}

