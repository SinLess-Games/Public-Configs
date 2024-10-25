#!/bin/zsh

# ------------------------------------------------------------------------------
# ZSH Plugins Management Script
# ------------------------------------------------------------------------------
# This script provides functions to manage Zsh plugins. 
# Author: Sinless Games
# ------------------------------------------------------------------------------

# Default plugins
plugins=(
    "git"
    "zsh-autosuggestions"
    "zsh-completions"
    "zsh-syntax-highlighting"
)

# Path to the plugins configuration file (YAML)
PLUGINS_CONFIG="$HOME/.configs/SinlessGames/zsh-plugins.yaml"

# ------------------------------------------------------------------------------
# Function: install_zsh_plugin
# Installs a Zsh plugin by cloning it from a Git repository.
# Usage: install_zsh_plugin <repository_url>
# ------------------------------------------------------------------------------
install_zsh_plugin() {
    local repo_url=$1
    local plugin_name=$(basename "$repo_url" .git)

    # Check if the plugin is already installed
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/$plugin_name" ]; then
        echo "Plugin '$plugin_name' is already installed."
    else
        # Clone the plugin repository
        echo "Installing plugin '$plugin_name' from $repo_url..."
        git clone "$repo_url" "$HOME/.oh-my-zsh/custom/plugins/$plugin_name"
        echo "Plugin '$plugin_name' installed."
    fi

    # Add plugin to the plugins array if not already added
    add_plugin_to_list "$plugin_name"
}

# ------------------------------------------------------------------------------
# Function: install_plugins_from_config
# Installs Zsh plugins from the YAML configuration file.
# ------------------------------------------------------------------------------
install_plugins_from_config() {
    if [ ! -f "$PLUGINS_CONFIG" ]; then
        echo "No configuration file found at $PLUGINS_CONFIG."
        return 1
    fi

    # Read the YAML file and install each plugin listed
    echo "Installing plugins from $PLUGINS_CONFIG..."
    local urls=$(grep -oP '(?<=- )https?://\S+' "$PLUGINS_CONFIG")

    for url in $urls; do
        install_zsh_plugin "$url"
    done

    echo "Plugins from configuration file installed."
}

# ------------------------------------------------------------------------------
# Function: add_plugin_to_list
# Adds a plugin to the plugins=() list if it's not already there.
# ------------------------------------------------------------------------------
add_plugin_to_list() {
    local plugin_name=$1

    if ! echo "${plugins[@]}" | grep -q "$plugin_name"; then
        echo "Adding '$plugin_name' to plugins list."
        plugins+=("$plugin_name")
    else
        echo "Plugin '$plugin_name' is already in the plugins list."
    fi
}

# ------------------------------------------------------------------------------
# Function: display_plugins_list
# Displays the current plugins array in proper format.
# ------------------------------------------------------------------------------
display_plugins_list() {
    echo "plugins=("
    for plugin in "${plugins[@]}"; do
        echo "    \"$plugin\""
    done
    echo ")"
}

# ------------------------------------------------------------------------------
# Load the script at the end
# ------------------------------------------------------------------------------
echo "ZSH plugin management loaded."
