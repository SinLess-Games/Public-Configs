# -------------------------------------------------------------------------------------------------------------
# Custom Prompt Setup - Show Git Root Directory with Relative Path or Current Directory
# -------------------------------------------------------------------------------------------------------------

# Function to display the Git repository root with the relative path within it
git_root_relative_path() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the Git root directory
    local git_root
    git_root=$(git rev-parse --show-toplevel)
    # Calculate the relative path from the Git root to the current directory
    local relative_path="${PWD#$git_root}"
    # Format relative path to start with "/" if it's not the root directory itself
    [[ -n "$relative_path" ]] && relative_path="/$relative_path"
    # Display the Git root directory name followed by the relative path
    printf "%s%s" "$(basename "$git_root")" "$relative_path"
  else
    # Display the current directory name if outside of a Git repository
    basename "$PWD"
  fi
}

# Customize the prompt to show username, machine, Git root with relative path, and prompt symbol
PROMPT='%F{cyan}%n@%m %F{yellow}$(git_root_relative_path) %F{white}%# %f'
