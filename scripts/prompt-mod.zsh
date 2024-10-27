# -------------------------------------------------------------------------------------------------------------
# Custom Prompt Setup - Show Git Root Directory with Relative Path or Current Directory
# -------------------------------------------------------------------------------------------------------------

# Function to get the root directory of the Git repository and the relative path within it
git_root_relative_path() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the Git repository root
    local git_root
    git_root=$(git rev-parse --show-toplevel)
    # Get the relative path from the Git root to the current directory
    local relative_path="${PWD#$git_root}"
    # Display the root directory name with relative path
    printf "%s%s" "$(basename "$git_root")" "$relative_path"
  else
    # Display the current directory name if not in a Git repository
    basename "$PWD"
  fi
}

# Customize the prompt to show username, machine, Git root with relative path, and prompt symbol
PROMPT='%F{cyan}%n@%m %F{yellow}$(git_root_relative_path) %F{white}%# %f'
