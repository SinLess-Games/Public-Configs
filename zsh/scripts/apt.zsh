function setup_apt() {
    if [ -f ~/.configs/SinlessGames/apt-packages.yaml ]; then
        log_info "Installing packages from ~/.configs/SinlessGames/apt-packages.yaml..."
        local packages=$(grep -oP '(?<=- )\S+' ~/.configs/SinlessGames/apt-packages.yaml)
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y $packages
        log_info "Packages installed."
    else
        log_error "No configuration file found at ~/.configs/SinlessGames/apt-packages.yaml."
        return 1
    fi
}