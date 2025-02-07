#!/bin/bash
# ScriptGrab v2.1 with Whiptail-based GUI and Installed Scripts Manager

# Define the ScriptGrab directory and version
SCRIPTGRAB_DIR="$HOME/scriptgrab"
SCRIPTGRAB_VERSION="v2.1"

# Ensure the ScriptGrab directory exists
mkdir -p "$SCRIPTGRAB_DIR"

# Add ScriptGrab directory to PATH if not already added
if [[ ":$PATH:" != *":$SCRIPTGRAB_DIR:"* ]]; then
    echo "export PATH=\$PATH:$SCRIPTGRAB_DIR" >> "$HOME/.bashrc"
    whiptail --title "PATH Updated" --msgbox "Added $SCRIPTGRAB_DIR to PATH.
Restart your terminal or run 'source ~/.bashrc' to apply changes." 10 60
fi

##############################################
# Functions using Whiptail for all dialogs   #
##############################################

# Display help information
function display_help() {
    local help_text="Usage: scriptgrab [command]\n\n"
    help_text+="Commands:\n"
    help_text+="  help            Show help message\n"
    help_text+="  list            List available remote scripts\n"
    help_text+="  install_remote  Download and install a remote script\n"
    help_text+="  install_local   Install a local script file\n"
    help_text+="  manage          Manage installed scripts (run/uninstall)\n"
    help_text+="  rm              Uninstall a script (by name)\n"
    help_text+="  autoremove      Remove all installed scripts\n"
    help_text+="  update          Update ScriptGrab\n"
    help_text+="  about           About ScriptGrab\n"
    help_text+="  exit            Exit\n"
    whiptail --title "ScriptGrab Help" --msgbox "$help_text" 20 60
}

# List available remote scripts
function list_scripts() {
    local scripts_text="Available remote scripts:\n"
    scripts_text+="  - brave-install\n"
    scripts_text+="  - disk-usage-checker\n\n"
    scripts_text+="Want to add your own script? See the GitHub repository!\n"
    scripts_text+="Add your .sh script to the 'sh' folder, and it will be included in the next version."
    whiptail --title "Available Remote Scripts" --msgbox "$scripts_text" 20 60
}

# Download and install a remote script
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
            whiptail --title "Error" --msgbox "Unknown remote script '$script_name'." 10 50
            return 1
            ;;
    esac

    whiptail --title "Installing Script" --infobox "Downloading and installing $script_name..." 10 50
    wget "$script_url" -O "$SCRIPTGRAB_DIR/$script_name" &>/dev/null && chmod +x "$SCRIPTGRAB_DIR/$script_name"

    if [[ $? -eq 0 ]]; then
        whiptail --title "Success" --msgbox "$script_name has been installed successfully.
You can now run it from anywhere using: $script_name" 10 60
    else
        whiptail --title "Error" --msgbox "Failed to install $script_name." 10 50
    fi
}

# Install a local script file
function install_local_script() {
    local file_path="$1"

    if [[ ! -f "$file_path" ]]; then
        whiptail --title "Error" --msgbox "File '$file_path' does not exist." 10 50
        return 1
    fi

    local script_name
    script_name="$(basename "$file_path")"
    
    cp "$file_path" "$SCRIPTGRAB_DIR/$script_name" && chmod +x "$SCRIPTGRAB_DIR/$script_name"
    if [[ $? -eq 0 ]]; then
        whiptail --title "Success" --msgbox "$script_name has been installed successfully from the local file.
You can now run it from anywhere using: $script_name" 10 60
    else
        whiptail --title "Error" --msgbox "Failed to install $script_name from the local file." 10 50
    fi
}

# Uninstall a script (by name)
function uninstall_script() {
    local script_name="$1"
    local script_path="$SCRIPTGRAB_DIR/$script_name"

    if [[ -f "$script_path" ]]; then
        if whiptail --title "Confirm Uninstall" --yesno "Are you sure you want to uninstall '$script_name'?" 10 50; then
            rm -f "$script_path"
            whiptail --title "Uninstalled" --msgbox "'$script_name' has been removed." 10 50
        else
            whiptail --title "Cancelled" --msgbox "Uninstallation canceled." 10 50
        fi
    else
        whiptail --title "Error" --msgbox "Script '$script_name' is not installed." 10 50
    fi
}

# Remove all installed scripts
function autoremove() {
    if whiptail --title "Confirm Autoremove" --yesno "Are you sure you want to remove all installed scripts?" 10 50; then
        rm -rf "$SCRIPTGRAB_DIR"/*
        whiptail --title "Success" --msgbox "All installed scripts have been removed." 10 50
    else
        whiptail --title "Cancelled" --msgbox "Autoremove canceled." 10 50
    fi
}

# Update ScriptGrab
function update_scriptgrab() {
    whiptail --title "Update ScriptGrab" --infobox "Updating ScriptGrab..." 10 50
    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/Uninstall.sh -O uninstall-scriptgrab.sh &>/dev/null
    chmod +x uninstall-scriptgrab.sh
    ./uninstall-scriptgrab.sh &>/dev/null

    wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/install-scriptgrab.sh -O install-scriptgrab.sh &>/dev/null
    chmod +x install-scriptgrab.sh
    ./install-scriptgrab.sh &>/dev/null

    whiptail --title "Updated" --msgbox "ScriptGrab has been updated." 10 50
}

# Display "about" information with ASCII art and version
function about_scriptgrab() {
    local about_text="..........................\n"
    about_text+="..........................\n"
    about_text+="..=%#:....................\n"
    about_text+="..#@%@*...................\n"
    about_text+="...:%@%%*.................\n"
    about_text+=".....-%%%%+...............\n"
    about_text+="......:%%%@=..............\n"
    about_text+=".....#%%@#................\n"
    about_text+="...+%%@%:.................\n"
    about_text+="..%%%%-.-=++=+==+==+==+=..\n"
    about_text+="..:+=...%%%%%%%%%%%%%%%%:.\n"
    about_text+="..........................\n"
    about_text+="..........................\n\n"
    about_text+="ScriptGrab version $SCRIPTGRAB_VERSION"
    whiptail --title "About ScriptGrab" --msgbox "$about_text" 20 60
}

##############################################
# New: Manage Installed Scripts Function     #
##############################################

function manage_installed_scripts() {
    local scripts=()
    # Gather all installed scripts (files) from SCRIPTGRAB_DIR
    for file in "$SCRIPTGRAB_DIR"/*; do
        if [[ -f "$file" ]]; then
            scripts+=("$(basename "$file")" "")
        fi
    done

    if [[ ${#scripts[@]} -eq 0 ]]; then
        whiptail --title "Manage Scripts" --msgbox "No installed scripts found." 10 50
        return
    fi

    local selected_script=$(whiptail --title "Installed Scripts" --menu "Select a script:" 20 60 10 "${scripts[@]}" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 ]]; then
        return
    fi

    local action=$(whiptail --title "Action" --menu "What do you want to do with '$selected_script'?" 15 60 2 \
         "run" "Run the script" \
         "rm" "Uninstall the script" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 ]]; then
        return
    fi

    case "$action" in
        run)
            # If xterm is available, use it to run the script in a new window.
            if command -v xterm &>/dev/null; then
                xterm -T "$selected_script" -e "$SCRIPTGRAB_DIR/$selected_script; read -p 'Press Enter to close'" &
            else
                # Otherwise, run in the current shell.
                "$SCRIPTGRAB_DIR/$selected_script"
            fi
            ;;
        rm)
            uninstall_script "$selected_script"
            ;;
        *)
            ;;
    esac
}

##############################################
# Main interactive menu (Whiptail-based)     #
##############################################

while true; do
    CHOICE=$(whiptail --title "ScriptGrab" --menu "Choose an option:" 22 60 10 \
        "help"            "Show help message" \
        "list"            "List available remote scripts" \
        "install_remote"  "Download and install a remote script" \
        "install_local"   "Install a local script file" \
        "manage"          "Manage installed scripts" \
        "rm"              "Uninstall a script (by name)" \
        "autoremove"      "Remove all installed scripts" \
        "update"          "Update ScriptGrab" \
        "about"           "About ScriptGrab" \
        "exit"            "Exit" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
        break
    fi

    case "$CHOICE" in
        help)
            display_help
            ;;
        list)
            list_scripts
            ;;
        install_remote)
            REMOTE_SCRIPT=$(whiptail --title "Install Remote Script" --inputbox "Enter the name of the remote script:" 10 60 3>&1 1>&2 2>&3)
            if [ $? -eq 0 ]; then
                install_script "$REMOTE_SCRIPT"
            fi
            ;;
        install_local)
            LOCAL_SCRIPT_PATH=$(whiptail --title "Install Local Script" --inputbox "Enter the full path to the local .sh script:" 10 60 3>&1 1>&2 2>&3)
            if [ $? -eq 0 ]; then
                install_local_script "$LOCAL_SCRIPT_PATH"
            fi
            ;;
        manage)
            manage_installed_scripts
            ;;
        rm)
            SCRIPT_TO_REMOVE=$(whiptail --title "Uninstall Script" --inputbox "Enter the name of the script to uninstall:" 10 60 3>&1 1>&2 2>&3)
            if [ $? -eq 0 ]; then
                uninstall_script "$SCRIPT_TO_REMOVE"
            fi
            ;;
        autoremove)
            autoremove
            ;;
        update)
            update_scriptgrab
            ;;
        about)
            about_scriptgrab
            ;;
        exit)
            break
            ;;
    esac
done

# End of ScriptGrab
