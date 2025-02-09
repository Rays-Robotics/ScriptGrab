#!/bin/bash

# ScriptGrab version and directory (XDG compliant)
SCRIPTGRAB_VERSION="v2.2"
SCRIPTGRAB_DIR="$HOME/.local/share/scriptgrab"

# Ensure the ScriptGrab directory exists
mkdir -p "$SCRIPTGRAB_DIR"

# Detect shell and set config file
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""

case "$SHELL_NAME" in
  bash)
    CONFIG_FILE="$HOME/.bashrc"
    ;;
  zsh)
    CONFIG_FILE="$HOME/.zshrc"
    ;;
  *)
    CONFIG_FILE="$HOME/.bashrc" # Default to bashrc, but warn user
    echo "Warning: Shell '$SHELL_NAME' detected. Adding to .bashrc as default. For best results, manually add the ScriptGrab directory to your shell's configuration if it's not bash or zsh."
    ;;
esac

# Add ScriptGrab directory to PATH if not already added
if [[ ":$PATH:" != *":$SCRIPTGRAB_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:\$SCRIPTGRAB_DIR\"" >> "$CONFIG_FILE"
    echo "Added $SCRIPTGRAB_DIR to PATH in '$CONFIG_FILE'. Restart your terminal or run 'source $CONFIG_FILE' to apply changes."
fi

# Function to display help
function display_help() {
    echo "Usage: scriptgrab [command]"
    echo "Commands:"
    echo "  help                  Show this help message."
    echo "  list                  List available remote scripts."
    echo "  local <file>          Install a local .sh script from the specified file path."
    echo "  about                 Show ScriptGrab version and information."
    echo "  <script>              Download and install the specified remote script."
    echo "  rm <script>           Uninstall (remove) the specified script."
    echo "  autoremove           Remove all installed scripts."
    echo "  update                Update ScriptGrab by reinstalling it."
}

# Function to list available remote scripts
function list_scripts() {
    echo "Available remote scripts:"
    echo "  - brave-install"
    echo "  - disk-usage-checker"
    echo
    echo "Want to add your own script? See the GitHub repository!"
    echo "Add your .sh script to the 'sh' folder, and it will be included in the next version."
}

# Function to download and install a remote script
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
            echo "Error: Unknown remote script '$script_name'."
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

# Function to install a local script file
function install_local_script() {
    local file_path="$1"

    if [[ ! -f "$file_path" ]]; then
        echo "Error: File '$file_path' does not exist."
        exit 1
    fi

    local script_name
    script_name="$(basename "$file_path")"

    cp "$file_path" "$SCRIPTGRAB_DIR/$script_name" && chmod +x "$SCRIPTGRAB_DIR/$script_name"
    if [[ $? -eq 0 ]]; then
        echo "$script_name has been installed successfully from local file."
        echo "You can now run it from anywhere using: $script_name"
    else
        echo "Error: Failed to install $script_name from local file."
    fi
}

# Function to uninstall a script
function uninstall_script() {
    local script_name="$1"
    local script_path="$SCRIPTGRAB_DIR/$script_name"

    if [[ -f "$script_path" ]]; then
        read -p "Are you sure you want to uninstall '$script_name'? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
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
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
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

# Function to display "about" information with ASCII art and version
function about_scriptgrab() {
    echo ".........................."
    echo ".........................."
    echo "..=%#:...................."
    echo "..#@%@*..................."
    echo "...:%@%%*................."
    echo ".....-%%%%+..............."
    echo "......:%%%@=.............."
    echo ".....#%%@#................"
    echo "...+%%@%:................."
    echo "..%%%%-.-=++=+==+==+==+=.."
    echo "..:+=...%%%%%%%%%%%%%%%%:."
    echo ".........................."
    echo ".........................."
    echo ""
    echo "ScriptGrab version $SCRIPTGRAB_VERSION"
}

# Main logic
case "$1" in
    help)
        display_help
        ;;
    list)
        list_scripts
        ;;
    local)
        if [[ -z "$2" ]]; then
            echo "Usage: scriptgrab local /path/to/script.sh"
            exit 1
        else
            install_local_script "$2"
        fi
        ;;
    about)
        about_scriptgrab
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
