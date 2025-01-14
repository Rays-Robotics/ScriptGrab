#!/bin/bash

# URL for the scriptgrab script
SCRIPT_URL="https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/scriptgrab-v1.sh"
SCRIPT_NAME="scriptgrab.sh"

# Download scriptgrab
echo "Downloading scriptgrab from $SCRIPT_URL..."
wget -q "$SCRIPT_URL" -O "$SCRIPT_NAME"

# Check if the download was successful
if [[ $? -eq 0 ]]; then
    echo "Download successful. Making $SCRIPT_NAME executable..."
    chmod +x "$SCRIPT_NAME"
    echo "$SCRIPT_NAME is now installed and executable."
    echo "To use it, run: ./$SCRIPT_NAME"
else
    echo "Error: Failed to download scriptgrab. Please check the URL and try again."
fi

