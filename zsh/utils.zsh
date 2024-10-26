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
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/zsh/scripts/"

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
    base_url="https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/configs/"

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

# create a reusable progress bar function for scripts
function progress_bar() {
    local duration=${1}
    local columns=$(tput cols)
    local progress_char="▓"
    local empty_char="░"
    local total_width=$((columns - 10))
    local progress=0
    local progress_width=0
    local remaining_width=0
    local sleep_duration=$((duration / total_width))

    while [ $progress -lt $total_width ]; do
        progress_width=$((progress + 1))
        remaining_width=$((total_width - progress))
        printf "\rProgress: [%-${progress_width}s%${remaining_width}s] %d%%" \
            "$(printf "%0.s$progress_char" $(seq 1 $progress))" \
            "$(printf "%0.s$empty_char" $(seq 1 $remaining_width))" \
            $((progress * 100 / total_width))
        sleep $sleep_duration
        ((progress++))
    done
    printf "\n"
}