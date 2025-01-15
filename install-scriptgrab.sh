#!/bin/bash

# Installer for ScriptGrab v2
echo "Installing ScriptGrab v2..."

# Define installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="scriptgrab"

# Download ScriptGrab
wget https://github.com/Rays-Robotics/ScriptGrab/raw/main/scriptgrab-v1 -O "$INSTALL_DIR/$SCRIPT_NAME"

# Make it executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "ScriptGrab has been installed! You can now use it by typing: scriptgrab"


