#!/bin/bash

# Installer for ScriptGrab v2
echo "Installing ScriptGrab v2..."

# Define installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="scriptgrab"

# Download ScriptGrab
sudo wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/scriptgrab-v2.sh -O "$INSTALL_DIR/$SCRIPT_NAME"

# Make it executable
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Confirm installation
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    echo "ScriptGrab v2 has been successfully installed!"
    echo "You can now use it by typing: scriptgrab"
else
    echo "Installation failed. Please check your permissions or try again."
fi
