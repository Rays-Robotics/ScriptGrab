#!/bin/bash

# Define the ScriptGrab directory
SCRIPTGRAB_DIR="$HOME/scriptgrab"

# Ensure the ScriptGrab directory exists
mkdir -p "$SCRIPTGRAB_DIR"

# Add ScriptGrab directory to PATH if not already added
if [[ ":$PATH:" != *":$SCRIPTGRAB_DIR:"* ]]; then
    echo "export PATH=\$PATH:$SCRIPTGRAB_DIR" >> "$HOME/.bashrc"
    echo "Added $SCRIPTGRAB_DIR to PATH. Restart your terminal or run 'source ~/.bashrc' to apply changes."
fi

# Function to display help
function display_help() {
    echo "Usage: scriptgrab [command]"
    echo "Commands:"
    echo "  help          Show this help message."
    echo "  list          List available scripts."
    echo "  <script>      Download and make the specified script executable."
    echo "  rm <script>   Uninstall (remove) the specified script."
    echo "  autoremove    Remove all installed scripts."
    echo "  update        Update ScriptGrab by reinstalling it."
}

# Function to list available scripts
function list_scripts() {
    echo "Available scripts:"
    echo "  - brave-install"
    echo "  - disk-usage-checker"
    echo
    echo "Want to add your own script? See the GitHub repository!"
    echo "Add your .sh script to the 'sh' folder, and it will be included in the next version."
}

# Function to download and install a script
function install_script() {
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
            echo "Error: Unknown script '$script_name'."
            exit 1
            ;;
    esac

    echo "Downloading and installing $script_name..."
    wget "$script_url" -O "$SCRIPTGRAB_DIR/$script_name" && chmod +x "$SCRIPTGRAB_DIR/$script_name"

    if [[ $? -eq 0 ]]; then
        echo "$script_name has been installed successfully."
        echo "You can now run it from anywhere using: $script_name"
    else
        echo "Error: Failed to install $script_name."
    fi
}

# Function to uninstall a script
function uninstall_script() {
    local script_name="$1"
    local script_path="$SCRIPTGRAB_DIR/$script_name"

    if [[ -f "$script_path" ]]; then
        read -p "Are you sure you want to uninstall '$script_name'? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            rm -f "$script_path"
            echo "'$script_name' has been removed."
        else
            echo "Uninstallation canceled."
        fi
    else
        echo "Error: Script '$script_name' is not installed."
    fi
}

# Function to remove all installed scripts
function autoremove() {
    read -p "Are you sure you want to remove all installed scripts? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$SCRIPTGRAB_DIR"/*
        echo "All installed scripts have been removed."
    else
        echo "Autoremove canceled."
    fi
}

# Function to update ScriptGrab
function update_scriptgrab() {
    echo "Updating ScriptGrab..."
    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/Uninstall.sh -O uninstall-scriptgrab.sh
    chmod +x uninstall-scriptgrab.sh
    ./uninstall-scriptgrab.sh

    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/install-scriptgrab.sh -O install-scriptgrab.sh
    chmod +x install-scriptgrab.sh
    ./install-scriptgrab.sh
}

# Main logic
case "$1" in
    help)
        display_help
        ;;
    list)
        list_scripts
        ;;
    rm)
        if [[ -z "$2" ]]; then
            echo "Error: Please specify the script to uninstall."
        else
            uninstall_script "$2"
        fi
        ;;
    autoremove)
        autoremove
        ;;
    update)
        update_scriptgrab
        ;;
    *)
        if [[ -z "$1" ]]; then
            display_help
        else
            install_script "$1"
        fi
        ;;
esac
