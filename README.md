# Public-Configs

This repository is designed to be modular, allowing for diverse installations. It provides different configurations that can be used independently or combined, depending on your needs. 

## Table of Contents

1. [ZSH](#zsh)
4. [Git](#git)
5. [Docker](#docker)
6. [VSCode](#vscode)

## ZSH

### Overview

[**ZSH**](./zsh) - This directory contains all configuration files for ZSH. It includes `.zshrc` and other related setup scripts, which help you set up a feature-rich ZSH environment quickly and easily.

This ZSH configuration is designed to:
- Provide a powerful terminal experience.
- Enable productivity-enhancing plugins like autosuggestions and syntax highlighting.
- Configure themes like Powerlevel10k for enhanced visual appeal and information density.

### Installation

To install the ZSH configuration, run the following command:

```zsh
curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.zshrc && source ~/.zshrc
```

Make sure to create and configure a `~/.config/SinlessGames/packages.yaml` file for dependencies:

```yaml
packages:
  # List your required packages here
```

### Installation

To install Tmux configuration:

```sh
curl -L -o ~/.tmux.conf https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/tmux/.tmux.conf
```

## Git

### Overview

[**Git**](./git) - Contains configuration for Git, such as `.gitconfig` and aliases that make interacting with Git more efficient, enabling faster workflow management.

### Installation

To install Git configuration:

```sh
curl -L -o ~/.gitconfig https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/git/.gitconfig
```

## Docker

### Overview

[**Docker**](./docker) - Provides Docker configuration files, ensuring that you can standardize your Docker environments across various machines. This includes `docker-compose` samples for common scenarios.

## VSCode

### Overview

[**VSCode**](./.vscode) - Contains configuration files for Visual Studio Code, including settings and key bindings that are developer-friendly and aim to boost productivity.

### Installation

To use the VSCode configuration, you can copy the relevant files to your VSCode settings directory.

## Inspiration

Managing multiple environments can be time-consuming. That's why this repository is built with modularity in mind. The goal is to provide a plug-and-play approach to configurations, allowing developers to save time and maintain consistent setups across different machines and environments.
