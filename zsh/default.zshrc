# Default .zshrc file for a basic Zsh setup with Oh My Zsh

# Set Zsh as the default shell
export SHELL=/bin/zsh

# Enable command auto-completion and history
autoload -Uz compinit && compinit
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups

# Set prompt
PROMPT='%n@%m %1~ %# '

# Add common directories to PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'

# Enable syntax highlighting if available
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load fzf (if installed)
if command -v fzf >/dev/null 2>&1; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# Source custom scripts
if [ -f ~/.zshrc_custom ]; then
  source ~/.zshrc_custom
fi

# Load Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
