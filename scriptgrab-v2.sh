#!/bin/bash

# ScriptGrab version and directory (XDG compliant)
SCRIPTGRAB_VERSION="v2.3"
SCRIPTGRAB_DIR="$HOME/.local/share/scriptgrab"

# Ensure the ScriptGrab directory exists
mkdir -p "$SCRIPTGRAB_DIR"

# Detect shell and set config file
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""

case "$SHELL_NAME" in
  bash) CONFIG_FILE="$HOME/.bashrc" ;;
  zsh) CONFIG_FILE="$HOME/.zshrc" ;;
  *)
    CONFIG_FILE="$HOME/.bashrc" # Default fallback
    echo "Warning: Unknown shell '$SHELL_NAME'. Defaulting to .bashrc."
    ;;
esac

# Add ScriptGrab directory to PATH if not already added
if [[ ":$PATH:" != *":$SCRIPTGRAB_DIR:"* ]]; then
    if ! grep -q "$SCRIPTGRAB_DIR" "$CONFIG_FILE"; then
        echo "export PATH=\"\$PATH:$SCRIPTGRAB_DIR\"" >> "$CONFIG_FILE"
        echo "Added $SCRIPTGRAB_DIR to PATH in '$CONFIG_FILE'. Restart or run 'source $CONFIG_FILE' to apply changes."
    fi
fi

# --- Utility function: safe download with sha256 verification ---
safe_download() {
    local url="$1"
    local output="$2"
    local checksum_url="$url.sha256"

    echo "Downloading: $url"
    if ! wget -q --show-progress -O "$output" "$url"; then
        echo "Error: Failed to download $url"
        return 1
    fi

    echo "Downloading checksum: $checksum_url"
    if ! wget -q -O "$output.sha256" "$checksum_url"; then
        echo "Warning: No checksum found for $url. Skipping verification."
        return 0
    fi

    echo "Verifying checksum..."
    if ! sha256sum -c "$output.sha256" --status; then
        echo "Error: SHA256 checksum mismatch for $output"
        rm -f "$output" "$output.sha256"
        return 1
    fi

    rm -f "$output.sha256"
    echo "Checksum verified for $output"
    return 0
}

# Function to display help
display_help() {
    cat <<EOF
Usage: scriptgrab [command]

Commands:
  help                  Show this help message.
  list                  List available remote scripts.
  local <file>          Install a local .sh script from the specified file path.
  about                 Show ScriptGrab version and info.
  <script>              Download and install the specified remote script.
  rm <script>           Uninstall (remove) the specified script.
  autoremove            Remove all installed scripts.
  update                Update ScriptGrab by reinstalling it.
EOF
}

# Function to list available remote scripts
list_scripts() {
    echo "Available remote scripts:"
    echo "  - brave-install"
    echo "  - disk-usage-checker"
    echo
    echo "Want to add your own? Contribute via GitHub!"
}

# Function to download and install a remote script
install_script() {
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

    local target="$SCRIPTGRAB_DIR/$script_name"

    if safe_download "$script_url" "$target"; then
        chmod +x "$target"
        echo "$script_name installed successfully. Run it with: $script_name"
    else
        echo "Installation failed for $script_name."
        exit 1
    fi
}

# Function to install a local script file
install_local_script() {
    local file_path="$1"

    if [[ ! -f "$file_path" ]]; then
        echo "Error: File '$file_path' does not exist."
        exit 1
    fi

    local script_name
    script_name="$(basename "$file_path")"
    local target="$SCRIPTGRAB_DIR/$script_name"

    if cp "$file_path" "$target" && chmod +x "$target"; then
        echo "$script_name installed successfully from local file. Run it with: $script_name"
    else
        echo "Error: Failed to install $script_name from local file."
        exit 1
    fi
}

# Function to uninstall a script
uninstall_script() {
    local script_name="$1"
    local script_path="$SCRIPTGRAB_DIR/$script_name"

    if [[ -f "$script_path" ]]; then
        read -rp "Uninstall '$script_name'? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -f "$script_path"
            echo "'$script_name' removed."
        else
            echo "Uninstallation canceled."
        fi
    else
        echo "Error: Script '$script_name' is not installed."
        exit 1
    fi
}

# Function to remove all installed scripts
autoremove() {
    read -rp "Remove ALL installed scripts? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$SCRIPTGRAB_DIR"/*
        echo "All installed scripts removed."
    else
        echo "Autoremove canceled."
    fi
}

# Function to update ScriptGrab
update_scriptgrab() {
    echo "Updating ScriptGrab..."
    local uninstall="uninstall-scriptgrab.sh"
    local install="install-scriptgrab.sh"

    if safe_download "https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/Beta/Uninstall.sh" "$uninstall"; then
        chmod +x "$uninstall" && ./"$uninstall"
    else
        echo "Error: Failed to download uninstall script."
        exit 1
    fi

    if safe_download "https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/Beta/install-scriptgrab.sh" "$install"; then
        chmod +x "$install" && ./"$install"
    else
        echo "Error: Failed to download install script."
        exit 1
    fi
}

# Function to display "about" information with ASCII art and version
about_scriptgrab() {
    cat <<'EOF'
..........................
..........................
..=%#:....................
..#@%@*...................
...:%@%%*.................
.....-%%%%+...............
......:%%%@=..............
.....#%%@#................
...+%%@%:.................
..%%%%-.-=++=+==+==+==+=..
..:+=...%%%%%%%%%%%%%%%%:.
..........................
..........................

EOF
    echo "ScriptGrab version $SCRIPTGRAB_VERSION"
}

# --- Main logic ---
case "$1" in
    help)       display_help ;;
    list)       list_scripts ;;
    local)      [[ -z "$2" ]] && echo "Usage: scriptgrab local /path/to/script.sh" && exit 1 || install_local_script "$2" ;;
    about)      about_scriptgrab ;;
    rm)         [[ -z "$2" ]] && echo "Error: Please specify the script to uninstall." && exit 1 || uninstall_script "$2" ;;
    autoremove) autoremove ;;
    update)     update_scriptgrab ;;
    *)          [[ -z "$1" ]] && display_help || install_script "$1" ;;
esac
