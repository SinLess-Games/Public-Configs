function setup_ohmyzsh() {
    # Install Oh My Zsh if it does not already exist
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh not found. Downloading and installing..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        log_info "Oh My Zsh installed successfully!"
    else
        log_info "Oh My Zsh already installed. Skipping installation."
    fi
    
    # Set the Zsh theme to Powerlevel10k in .zshrc if not already set
    if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
        log_info "Setting Powerlevel10k as the default theme in .zshrc"
        sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    else
        log_info "Powerlevel10k theme is already set in .zshrc"
    fi
}
