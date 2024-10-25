function bordered_anscii() {
    local msg="$1"

    # Define colors
    local blue="\e[34m"   # Blue color for the border
    local reset="\e[0m"   # Reset color
    local gold="\e[38;5;220m"  # Gold color for figlet text

    # Generate the figlet text with gold color and store it in a variable
    local figlet_text=$(figlet -f slant "$msg")

    # Calculate the width of the border based on the length of the longest line of figlet text
    local width=$(echo "$figlet_text" | wc -L)
    local border_width=$((width + 4))  # Add 4 for the padding (2 spaces on each side)

    # Print the top border
    echo -e "${blue}$(printf '%0.s#' $(seq 1 $border_width))${reset}"

    # Print an empty line (with borders on the sides)
    echo -e "${blue}##${reset}$(printf '%*s' $width '')${blue}##${reset}"

    # Print the figlet text with padding and borders
    while IFS= read -r line; do
        echo -e "${blue}##${reset}  ${gold}${line}${reset}  ${blue}##${reset}"
    done <<< "$figlet_text"

    # Print another empty line (with borders on the sides)
    echo -e "${blue}##${reset}$(printf '%*s' $width '')${blue}##${reset}"

    # Print the bottom border
    echo -e "${blue}$(printf '%0.s#' $(seq 1 $border_width))${reset}"
}