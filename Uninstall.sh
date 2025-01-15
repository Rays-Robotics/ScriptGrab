#!/bin/bash

# Uninstaller for ScriptGrab v2
echo "Uninstalling ScriptGrab v2..."

# Define installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="scriptgrab"

# Remove the scriptgrab binary
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    sudo rm "$INSTALL_DIR/$SCRIPT_NAME"
    echo "ScriptGrab v2 has been uninstalled successfully."
else
    echo "Error: ScriptGrab v2 is not installed in $INSTALL_DIR."
fi

# Optionally, remove residual scriptgrab files from the user's home directory
SCRIPTGRAB_DIR="$HOME/.scriptgrab"
if [[ -d "$SCRIPTGRAB_DIR" ]]; then
    rm -rf "$SCRIPTGRAB_DIR"
    echo "Removed residual files from $SCRIPTGRAB_DIR."
else
    echo "No residual files found in $SCRIPTGRAB_DIR."
fi

echo "Uninstallation complete."
