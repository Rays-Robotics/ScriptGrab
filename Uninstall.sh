#!/bin/bash

# Define the ScriptGrab directory
SCRIPTGRAB_DIR="$HOME/scriptgrab"

# Function to remove ScriptGrab from PATH
remove_from_path() {
    if grep -q "$SCRIPTGRAB_DIR" "$HOME/.bashrc"; then
        sed -i "\|$SCRIPTGRAB_DIR|d" "$HOME/.bashrc"
        echo "Removed $SCRIPTGRAB_DIR from PATH. Restart your terminal or run 'source ~/.bashrc' to apply changes."
    else
        echo "$SCRIPTGRAB_DIR is not in PATH."
    fi
}

# Confirm uninstallation
read -p "Are you sure you want to uninstall ScriptGrab? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Uninstallation canceled."
    exit 0
fi

# Optionally remove all packages
if [[ -d "$SCRIPTGRAB_DIR" ]]; then
    read -p "Do you want to uninstall all packages and delete the ScriptGrab directory? (y/n): " remove_packages
    if [[ "$remove_packages" == "y" || "$remove_packages" == "Y" ]]; then
        rm -rf "$SCRIPTGRAB_DIR"
        echo "All packages and the ScriptGrab directory have been removed."
    else
        echo "The ScriptGrab directory and packages have been retained."
    fi
else
    echo "ScriptGrab directory not found."
fi

# Remove ScriptGrab from PATH
remove_from_path

echo "ScriptGrab has been uninstalled."

