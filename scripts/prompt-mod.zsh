# -------------------------------------------------------------------------------------------------------------
# Custom Prompt Setup - Show Git Root Directory with Relative Path or Current Directory
# -------------------------------------------------------------------------------------------------------------

# Function to display the Git root directory with the relative path within it
git_root_relative_path() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the Git repository root
    local git_root
    git_root=$(git rev-parse --show-toplevel)
    
    # Get the relative path from the Git root to the current directory
    local relative_path
    relative_path=$(realpath --relative-to="$git_root" "$PWD")
    
    # Display the root name with relative path, ensuring only one slash
    if [ -n "$relative_path" ]; then
      printf "%s/%s" "$(basename "$git_root")" "$relative_path"
    else
      printf "%s" "$(basename "$git_root")"
    fi
  else
    # Display just the current directory name if not in a Git repository
    basename "$PWD"
  fi
}

# Customize the prompt to show username, machine, Git root with relative path, and prompt symbol
PROMPT='%F{cyan}%n@%m %F{yellow}$(git_root_relative_path) %F{white}%# %f'
