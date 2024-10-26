function setup_ohmyzsh() {
    # download oh-my-zsh if not exists
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh not found. Downloading from the repository..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        log_info "Oh My Zsh downloaded successfully!"
    else
        log_info "Oh My Zsh already exists. Skipping download."
    fi
    
    # Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
}