function setup_p10k() {
  # download p10k theme if not exists
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        log_info "Powerlevel10k theme not found. Downloading from the repository..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        log_info "Powerlevel10k theme downloaded successfully!"
    else
        log_info "Powerlevel10k theme already exists. Skipping download."
    fi

    # Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
}