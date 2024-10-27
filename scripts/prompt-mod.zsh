# -------------------------------------------------------------------------------------------------------------
# Custom Prompt Setup - Display Only Root of Git Repository
# -------------------------------------------------------------------------------------------------------------

# Function to display the root of the current Git repository or the current directory if not in a Git repo
git_root_prompt() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the top-level directory of the Git repository
    git rev-parse --show-toplevel | xargs basename
  else
    # If not in a Git repository, display the current directory's name
    basename "$PWD"
  fi
}

# Customize the prompt to include only the Git root directory
PROMPT='%F{cyan}%n@%m %F{yellow}$(git_root_prompt) %F{white}%# %f'
