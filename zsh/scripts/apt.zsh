# Ensure the configuration file exists; if not, download it from the repository
if [ ! -f ~/.configs/SinlessGames/apt-packages.yaml ]; then
    log_info "Configuration file not found. Downloading from repository..."
    mkdir -p ~/.configs/SinlessGames
    curl -o ~/.configs/SinlessGames/apt-packages.yaml https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/configs/apt-packages.yaml
fi

function setup_apt() {
    if [ -f ~/.configs/SinlessGames/apt-packages.yaml ]; then
        log_info "Installing packages from ~/.configs/SinlessGames/apt-packages.yaml..."
        
        # Extract package names from configuration file
        local packages=$(grep -oP '(?<=- )\S+' ~/.configs/SinlessGames/apt-packages.yaml)
        
        # Update and upgrade system packages
        sudo apt update
        sudo apt upgrade -y
        
        # Install packages from the configuration
        sudo apt install -y $packages
        log_info "Packages installed successfully."
    else
        log_error "Configuration file not found at ~/.configs/SinlessGames/apt-packages.yaml."
        return 1
    fi
}
