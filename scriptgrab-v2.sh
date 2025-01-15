#!/bin/bash

# ScriptGrab - A simple script manager

SCRIPT_DIR="$HOME/scriptgrab"

# Ensure the script directory exists
mkdir -p "$SCRIPT_DIR"

# Add ScriptGrab directory to PATH if not already present
if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
  echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$HOME/.bashrc"
  export PATH="$PATH:$SCRIPT_DIR"
fi

# Display help message
function display_help() {
  echo "Usage: scriptgrab [command] [options]"
  echo "Commands:"
  echo "  list           - List available scripts."
  echo "  <script-name>  - Install a script by name."
  echo "  rm <script>    - Uninstall a script."
  echo "  autoremove     - Remove all installed scripts."
  echo "  update         - Update ScriptGrab."
  echo "  --local <path> - Install a script from a local file."
  echo "  help           - Display this help message."
}

# Install a script by name
function install_script() {
  local script_name="$1"
  local script_url=""
  
  case "$script_name" in
    "brave-install")
      script_url="https://github.com/Rays-Robotics/Brave-Linux-Installer/raw/refs/heads/main/Linux-brave-installer.v1.sh"
      ;;
    "disk-usage-checker")
      script_url="https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/Sh/Disk-usage-checker"
      ;;
    *)
      echo "Error: Unknown script '$script_name'."
      return 1
      ;;
  esac

  # Download the script to the script directory
  wget "$script_url" -O "$SCRIPT_DIR/$script_name"
  chmod +x "$SCRIPT_DIR/$script_name"

  echo "Script '$script_name' has been installed and is available globally."
  echo "Run it using: $script_name"
}

# Install a local script
function install_local_script() {
  local script_path="$1"

  if [[ -z "$script_path" ]]; then
    echo "Error: No script path provided."
    echo "Usage: scriptgrab --local <path-to-script>"
    exit 1
  fi

  if [[ ! -f "$script_path" ]]; then
    echo "Error: File not found at '$script_path'."
    exit 1
  fi

  # Copy the script to the ScriptGrab directory
  local script_name
  script_name=$(basename "$script_path")
  cp "$script_path" "$SCRIPT_DIR/$script_name"
  chmod +x "$SCRIPT_DIR/$script_name"

  echo "Script '$script_name' has been installed and is available globally."
  echo "Run it using: $script_name"
}

# Uninstall a script
function uninstall_script() {
  local script_name="$1"

  if [[ -z "$script_name" ]]; then
    echo "Error: No script specified to remove."
    exit 1
  fi

  if [[ -f "$SCRIPT_DIR/$script_name" ]]; then
    rm "$SCRIPT_DIR/$script_name"
    echo "Script '$script_name' has been removed."
  else
    echo "Error: Script '$script_name' not found."
  fi
}

# Main logic
if [[ "$1" == "help" || -z "$1" ]]; then
  display_help
  exit 0
fi

case "$1" in
  list)
    echo "Available scripts:"
    echo "  brave-install"
    echo "  disk-usage-checker"
    echo "To add your own scripts, contribute via GitHub!"
    ;;
  rm)
    uninstall_script "$2"
    ;;
  autoremove)
    rm -rf "$SCRIPT_DIR"/*
    echo "All scripts have been removed."
    ;;
  update)
    echo "Updating ScriptGrab..."
    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/Uninstall.sh -O uninstall.sh
    chmod +x uninstall.sh
    ./uninstall.sh
    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/install-scriptgrab.sh -O install-scriptgrab.sh
    chmod +x install-scriptgrab.sh
    ./install-scriptgrab.sh
    ;;
  --local)
    install_local_script "$2"
    ;;
  *)
    install_script "$1"
    ;;
esac
