#!/bin/zsh

# -------------------------------------------------------------------------
# ZSH Plugins Management Script
# -------------------------------------------------------------------------
# This script provides functions to manage Zsh plugins, allowing automated
# installation from a configuration file or individual repository URLs.
# Author: Sinless Games
# -------------------------------------------------------------------------

# Default plugins
plugins=(
    "git"
    "zsh-autosuggestions"
    "zsh-completions"
    "zsh-syntax-highlighting"
)

# Path to the plugins configuration file (YAML)
PLUGINS_CONFIG="$HOME/.configs/SinlessGames/zsh-plugins.yaml"

# -------------------------------------------------------------------------
# Function: install_zsh_plugin
# Installs a Zsh plugin by cloning it from a Git repository, adds it to 
# the plugins array and configuration file if not already listed.
# Usage: install_zsh_plugin <repository_url>
# -------------------------------------------------------------------------
install_zsh_plugin() {
    local repo_url=$1
    local plugin_name=$(basename "$repo_url" .git)

    # Check if the plugin is already installed
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/$plugin_name" ]; then
        log_info "Plugin '$plugin_name' is already installed."
    else
        # Clone the plugin repository
        log_info "Installing plugin '$plugin_name' from $repo_url..."
        git clone "$repo_url" "$HOME/.oh-my-zsh/custom/plugins/$plugin_name"
        log_info "Plugin '$plugin_name' installed successfully."
    fi

    # Add plugin to the plugins list if not already present
    add_plugin_to_list "$plugin_name"
    # Add plugin to configuration file if not already there
    add_plugin_to_config "$repo_url"
}

# -------------------------------------------------------------------------
# Function: install_plugins_from_config
# Installs Zsh plugins from the YAML configuration file.
# -------------------------------------------------------------------------
install_plugins_from_config() {
    # Fetch config if it doesn't exist
    if [ ! -f "$PLUGINS_CONFIG" ]; then
        log_warn "No configuration file found at $PLUGINS_CONFIG. Fetching from repository..."
        curl -o "$PLUGINS_CONFIG" "https://raw.githubusercontent.com/SinLess-Games/Public-Configs/main/configs/zsh-plugins.yaml"
    fi

    # Read the YAML file and install each plugin listed
    log_info "Installing plugins from $PLUGINS_CONFIG..."
    local urls=$(grep -oP '(?<=- )https?://\S+' "$PLUGINS_CONFIG")

    for url in $urls; do
        install_zsh_plugin "$url"
    done

    log_info "Plugins from configuration file installed."
}

# -------------------------------------------------------------------------
# Function: add_plugin_to_list
# Adds a plugin to the plugins=() list if it's not already there.
# -------------------------------------------------------------------------
add_plugin_to_list() {
    local plugin_name=$1

    if ! echo "${plugins[@]}" | grep -q "$plugin_name"; then
        log_info "Adding '$plugin_name' to plugins list."
        plugins+=("$plugin_name")
    else
        log_info "Plugin '$plugin_name' is already in the plugins list."
    fi
}

# -------------------------------------------------------------------------
# Function: add_plugin_to_config
# Adds a plugin's repository URL to the configuration YAML file if not present.
# -------------------------------------------------------------------------
add_plugin_to_config() {
    local repo_url=$1
    if ! grep -q "$repo_url" "$PLUGINS_CONFIG"; then
        log_info "Adding '$repo_url' to $PLUGINS_CONFIG."
        echo "- $repo_url" >> "$PLUGINS_CONFIG"
    else
        log_info "Plugin '$repo_url' already exists in the configuration file."
    fi
}

# -------------------------------------------------------------------------
# Function: display_plugins_list
# Displays the current plugins array in proper format.
# -------------------------------------------------------------------------
display_plugins_list() {
    echo "plugins=("
    for plugin in "${plugins[@]}"; do
        echo "    \"$plugin\""
    done
    echo ")"
}

# -------------------------------------------------------------------------
# Initialization message
# -------------------------------------------------------------------------
log_info "ZSH plugin management script loaded."
