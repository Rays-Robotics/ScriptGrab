#!/bin/bash

# List of available scripts and their URLs
declare -A scripts=(
    ["brave-install"]="https://github.com/Rays-Robotics/Brave-Linux-Installer/raw/refs/heads/main/Linux-brave-installer.v1.sh"
)

# Function to display help
function display_help {
    echo "Usage: ./scriptgrab.sh [option]"
    echo "Options:"
    echo "  help         Show this help message"
    echo "  list         List all available scripts"
    echo "  <script>     Download and make the specified script executable"
    echo "  rm <script>  Uninstall (remove) the specified script"
}

# Function to list available scripts
function list_scripts {
    echo "Available scripts:"
    for script in "${!scripts[@]}"; do
        echo "  - $script"
    done
    echo ""
    echo "Want to add your own script? See the GitHub repository!"
    echo "Add your .sh script to the 'sh' folder, and it will be included in the next version."
}

# Main functionality
if [[ $# -eq 0 ]]; then
    echo "Welcome to scriptgrab!"
    echo "Type 'help' for usage, 'list' to view scripts, or enter a script name."
    read -p "Enter your choice: " choice
else
    choice=$1
fi

# Check if the user wants to remove a script
if [[ $choice == rm* ]]; then
    script_to_remove=${choice#rm }
    if [[ -f $script_to_remove ]]; then
        read -p "Are you sure you want to uninstall '$script_to_remove'? (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            rm "$script_to_remove"
            echo "'$script_to_remove' has been removed."
        else
            echo "Uninstallation canceled."
        fi
    else
        echo "Error: Script '$script_to_remove' not found."
    fi
    exit 0
fi

# Handle other commands
case $choice in
    help)
        display_help
        ;;
    list)
        list_scripts
        ;;
    *)
        if [[ -n "${scripts[$choice]}" ]]; then
            echo "Downloading and making $choice executable..."
            wget -q "${scripts[$choice]}" -O "$choice"
            chmod +x "$choice"
            echo "$choice has been downloaded and made executable."
            echo "To use it, run: ./$choice"
        else
            echo "Error: Script '$choice' not found. Use 'list' to view available scripts."
        fi
        ;;
esac

