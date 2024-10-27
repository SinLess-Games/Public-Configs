# -------------------------------------------------------------------------------------------------------------
# Custom Prompt Setup - Show Only the Git Root Directory or Current Directory
# -------------------------------------------------------------------------------------------------------------

# Function to get the root directory name of the Git repository or current directory if outside a Git repo
git_root_or_cwd() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Display only the name of the Git repository root
    basename "$(git rev-parse --show-toplevel)"
  else
    # Display the current directory name
    basename "$PWD"
  fi
}

# Customize the prompt to show only username, machine, and Git root or current directory
PROMPT='%F{cyan}%n@%m %F{yellow}$(git_root_or_cwd) %F{white}%# %f'
