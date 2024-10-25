# 🚀 Zsh Configuration for SinLess Games LLC

Welcome to the Zsh configuration for SinLess Games LLC! This setup is designed to simplify and enhance your terminal experience, making it easy to install everything you need with just one command.

## 🔧 Installation

To install this configuration, simply copy and paste the command below into your terminal:

```zsh
curl -L -o ~/.zshrc https://raw.githubusercontent.com/SinLess-Games/Public-Configs/refs/heads/main/zsh/.zshrc && source ~/.zshrc
```

This will download the configuration file and apply it immediately, setting up your environment in seconds. 🎉

## 📋 Requirements

This configuration requires a `~/.config/SinlessGames/apt-packages.yaml` file to be properly set up. Make sure to create and configure the following file before installation:

```yaml
packages:
  # List your required packages here
```

## 💡 Inspiration

Managing hundreds of dependencies across various virtual machines can be exhausting. That's why I created a `.zshrc` file that could fully install itself with a single command, and be just as easily uninstalled. This configuration is built to save time and streamline your development workflow. ⏱️💻

Feel free to customize it to suit your needs! ✨
