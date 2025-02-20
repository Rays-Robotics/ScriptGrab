#!/bin/bash

# Define the ScriptGrab directory
SCRIPTGRAB_DIR="$HOME/scriptgrab"

# Detect the shell (default to bash)
USER_SHELL=$(basename "$SHELL")
CONFIG_FILES=("$HOME/.bashrc" "$HOME/.zshrc")

# Function to remove ScriptGrab from PATH in config files
remove_from_path() {
    for CONFIG_FILE in "${CONFIG_FILES[@]}"; do
        if [[ -f "$CONFIG_FILE" ]]; then
            if grep -q "$SCRIPTGRAB_DIR" "$CONFIG_FILE"; then
                echo "Found ScriptGrab path in $CONFIG_FILE."
                
                # Create a backup before modifying
                cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
                echo "Backup created: $CONFIG_FILE.bak"
                
                # macOS compatibility: sed -i requires an argument
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "\|$SCRIPTGRAB_DIR|d" "$CONFIG_FILE"
                else
                    sed -i "\|$SCRIPTGRAB_DIR|d" "$CONFIG_FILE"
                fi
                
                echo "Removed $SCRIPTGRAB_DIR from $CONFIG_FILE. Restart your terminal or run 'source $CONFIG_FILE' to apply changes."
            else
                echo "No ScriptGrab path found in $CONFIG_FILE."
            fi
        fi
    done
}

# Confirm uninstallation
read -p "Are you sure you want to uninstall ScriptGrab? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Uninstallation canceled."
    exit 0
fi

# Check if ScriptGrab directory exists before attempting deletion
if [[ -d "$SCRIPTGRAB_DIR" ]]; then
    read -p "Do you want to delete all ScriptGrab files? (y/n): " remove_files
    if [[ "$remove_files" == "y" || "$remove_files" == "Y" ]]; then
        read -p "Are you absolutely sure? This action cannot be undone. (y/n): " final_confirm
        if [[ "$final_confirm" == "y" || "$final_confirm" == "Y" ]]; then
            rm -rf "$SCRIPTGRAB_DIR"
            echo "ScriptGrab directory and all packages have been deleted."
        else
            echo "Deletion canceled. ScriptGrab directory retained."
        fi
    else
        echo "ScriptGrab directory and packages have been kept."
    fi
else
    echo "ScriptGrab directory not found. Nothing to delete."
fi

# Remove ScriptGrab from PATH
remove_from_path

echo "ScriptGrab has been uninstalled successfully."
