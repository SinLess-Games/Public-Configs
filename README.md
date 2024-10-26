# Public-Configs

This repository is modular by design, enabling flexible and secure installations across diverse environments. Configurations are customizable, allowing you to use them independently or combine them to suit your specific setup needs.

## Table of Contents

1. [ZSH](#zsh)
2. [VSCode](#vscode)

## ZSH

### Overview

[**ZSH**](./zsh) - This directory holds configuration files for ZSH, including `.zshrc` and setup scripts designed to create a robust, feature-rich environment.

Key features:
- Enhanced terminal experience with productivity-oriented plugins (e.g., autosuggestions, syntax highlighting).
- Visually appealing and information-dense themes like Powerlevel10k.
- Automatic health checks and self-healing capabilities to ensure a smooth, error-free setup.

### Installation

Run the following command to install the ZSH configuration:

```zsh
curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.zshrc && source ~/.zshrc
```

> **Note**: You can customize the apt packages installed by modifying `~/.config/SinlessGames/apt-packages.yaml`.

### Automatic Health Checks
Each time the terminal launches, this configuration performs an auto-check of essential packages and configurations to ensure consistency and prevent setup issues.

## VSCode

### Overview

[**VSCode**](./.vscode) - Contains configuration files for Visual Studio Code, including settings and key bindings designed to enhance developer productivity.

### Installation

To apply the VSCode configuration, either copy the files to your VSCode settings directory or configure your editor to reference this repository’s settings.

## Inspiration

Creating consistent environments across machines can be challenging. Public-Configs embraces modularity and self-healing principles, offering a streamlined approach to configuration management that minimizes setup time and ensures a reliable, consistent environment across devices.