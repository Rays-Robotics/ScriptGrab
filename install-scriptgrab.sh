#!/bin/bash
# Installer for ScriptGrab v2.1 GUI Edition
# This installer checks for and installs all required dependencies
# for the main ScriptGrab script.

echo "Installing ScriptGrab v2.1 GUI Edition..."

#########################################
# Function: Map dependency names to distro package names
#########################################
map_package_name() {
    local dep="$1"
    local pkg_name="$dep"
    # For whiptail, use the package name "whiptail" on Debian/Ubuntu,
    # and "newt" on other distributions.
    if [[ "$dep" == "whiptail" ]]; then
        if command -v apt-get &>/dev/null; then
            pkg_name="whiptail"
        else
            pkg_name="newt"
        fi
    fi
    echo "$pkg_name"
}

#########################################
# Function: Install a dependency using the available package manager
#########################################
install_dependency() {
    local dep="$1"
    local pkg_name
    pkg_name=$(map_package_name "$dep")
    if command -v apt-get &>/dev/null; then
        echo "Using apt-get to install $pkg_name..."
        sudo apt-get update && sudo apt-get install -y "$pkg_name"
    elif command -v dnf &>/dev/null; then
        echo "Using dnf to install $pkg_name..."
        sudo dnf install -y "$pkg_name"
    elif command -v pacman &>/dev/null; then
        echo "Using pacman to install $pkg_name..."
        sudo pacman -Sy --noconfirm "$pkg_name"
    elif command -v yum &>/dev/null; then
        echo "Using yum to install $pkg_name..."
        sudo yum install -y "$pkg_name"
    else
        echo "Could not determine your package manager."
        echo "Please install '$pkg_name' manually and re-run this installer."
        exit 1
    fi
}

#########################################
# Install required dependencies for the main script
#########################################
REQUIRED_DEPS=("wget" "whiptail")
for dep in "${REQUIRED_DEPS[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        echo "Required dependency '$dep' is not installed. Installing it now..."
        install_dependency "$dep"
        # Check again after installation.
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: Could not install '$dep'. Please install it manually and re-run this installer."
            exit 1
        fi
    fi
done

#########################################
# Optional dependency: xterm (for running scripts in a new window)
#########################################
if ! command -v xterm &>/dev/null; then
    echo "Optional dependency 'xterm' is not installed."
    read -p "Would you like to install xterm for a better script-running experience? (y/N): " install_xterm_choice
    if [[ "$install_xterm_choice" =~ ^[Yy]$ ]]; then
        install_dependency "xterm"
    else
        echo "xterm will not be installed. The scripts will run in the current terminal."
    fi
fi

#########################################
# Download and install ScriptGrab
#########################################
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="scriptgrab"
SCRIPT_URL="https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/Gui-edition/scriptgrab-v2.1_gui.sh"

echo "Downloading ScriptGrab from $SCRIPT_URL..."
sudo wget "$SCRIPT_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"

echo "Making the script executable..."
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

#########################################
# Confirm installation
#########################################
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    echo "ScriptGrab v2.1 GUI Edition has been successfully installed!"
    echo "You can now use it by typing: scriptgrab"
else
    echo "Installation failed. Please check your permissions or try again."
fi
