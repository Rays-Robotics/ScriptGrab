#!/bin/bash

# ScriptGrab v2
# A lightweight script manager for downloading, managing, and uninstalling shell scripts.

SCRIPT_DIR="$HOME/.scriptgrab"
SCRIPTS_FILE="$SCRIPT_DIR/scripts.list"
INSTALL_DIR="/usr/local/bin"  # This is where we will store the downloaded scripts
USER_BIN_DIR="$HOME/bin"      # Fallback directory if /usr/local/bin is not accessible

# Ensure the script directory exists
mkdir -p "$SCRIPT_DIR"

# Ensure $USER_BIN_DIR exists if fallback is needed
mkdir -p "$USER_BIN_DIR"

# Function to display help
show_help() {
    echo "Usage: scriptgrab [command] [package]"
    echo ""
    echo "Commands:"
    echo "  help         Show this help message"
    echo "  list         List available scripts"
    echo "  [package]    Download and install the specified package"
    echo "  rm [package] Uninstall the specified package"
}

# Function to list available scripts
list_scripts() {
    echo "Available scripts:"
    echo "  - brave-install"
    echo "  - disk-usage-checker"
    echo ""
    echo "Want to add your own script? See the GitHub repository!"
    echo "Add your .sh script to the 'sh' folder, and it will be included in the next version."
}

# Function to download a script
download_script() {
    local script_name="$1"
    local script_url=""

    case "$script_name" in
        brave-install)
            script_url="https://github.com/Rays-Robotics/Brave-Linux-Installer/raw/refs/heads/main/Linux-brave-installer.v1.sh"
            ;;
        disk-usage-checker)
            script_url="https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/Sh/Disk-usage-checker"
            ;;
        *)
            echo "Error: Unknown package '$script_name'. Use 'scriptgrab list' to see available scripts."
            exit 1
            ;;
    esac

    echo "Downloading and making $script_name executable..."

    # Try downloading to /usr/local/bin
    if sudo wget "$script_url" -O "$INSTALL_DIR/$script_name"; then
        sudo chmod +x "$INSTALL_DIR/$script_name"
        echo "$script_name has been downloaded and made executable in $INSTALL_DIR."
    # Fallback to user's bin directory if /usr/local/bin fails
    elif wget "$script_url" -O "$USER_BIN_DIR/$script_name"; then
        chmod +x "$USER_BIN_DIR/$script_name"
        echo "$script_name has been downloaded and made executable in $USER_BIN_DIR."
    else
        echo "Error: Failed to download or make $script_name executable."
        exit 1
    fi

    echo "You can now run it by typing: $script_name"
}

# Function to uninstall a script
remove_script() {
    local script_name="$1"
    local script_path="$INSTALL_DIR/$script_name"

    if [[ -f "$script_path" ]]; then
        read -p "Are you sure you want to uninstall '$script_name'? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
            sudo rm "$script_path"
            echo "'$script_name' has been removed."
        else
            echo "Uninstall canceled."
        fi
    else
        echo "Error: Script '$script_name' not found."
    fi
}

# Main logic
case "$1" in
    help)
        show_help
        ;;
    list)
        list_scripts
        ;;
    rm)
        if [[ -z "$2" ]]; then
            echo "Error: Please specify a package to remove. Use 'scriptgrab rm [package]'."
        else
            remove_script "$2"
        fi
        ;;
    *)
        if [[ -z "$1" ]]; then
            show_help
        else
            download_script "$1"
        fi
        ;;
esac
