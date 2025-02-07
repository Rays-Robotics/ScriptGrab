# ScriptGrab - Experimental Beta (GUI Edition)

> **Warning:** This is an **experimental beta branch** featuring a fully interactive Whiptail-based GUI for managing your scripts.  
> **Bugs may be present.** If you prefer a stable experience without potential graphical glitches—and a smaller footprint—please switch to the [main branch](https://github.com/Rays-Robotics/ScriptGrab) which only includes the CLI version.  
>  
> **Note:** This GUI version is substantially larger than the CLI-only version due to the additional graphical interface and enhanced dependency support.

**ScriptGrab** is a lightweight and powerful script manager designed to make downloading, managing, and running shell scripts a breeze. The latest experimental version features a fully interactive Whiptail-based GUI for **all** user interactions—no more typing multiple commands!

---

## Features

- **Whiptail-Based GUI**:  
  Every interaction—from help screens to installing, updating, and managing scripts—is handled via intuitive Whiptail dialogs.
- **Script Management**:  
  Easily download and run remote scripts without remembering complex commands.
- **Local Script Installation**:  
  Install your own shell scripts through the interactive interface.
- **Manage Installed Scripts**:  
  View, run, or uninstall any installed script using a simple menu.
- **About Section**:  
  Get detailed tool information, complete with stylized ASCII art and version details.
- **Update Functionality**:  
  Seamlessly update ScriptGrab to the latest version right from the GUI.
- **Uninstall Functionality**:  
  Remove unwanted scripts effortlessly.
- **Multi-Distro Dependency Handling**:  
  The installer automatically detects and installs required dependencies (e.g., `wget`, `whiptail`, and optionally `xterm`) on Debian/Ubuntu, Fedora, Arch, and other Linux distributions.
- **Expandable & Community-Driven**:  
  Add your own scripts to the repository for inclusion in future updates. Contributions are always welcome!

---

## Getting Started

### Installation

To install **ScriptGrab v2.1 GUI Edition (Experimental Beta)**, run the following commands in your terminal. The installer will automatically detect your Linux distribution and install any missing dependencies, setting up the full Whiptail-based interface:

```bash
wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/Gui-edition/install-scriptgrab.sh -O install-scriptgrab.sh
chmod +x install-scriptgrab.sh
./install-scriptgrab.sh
```

> **Note:**  
> The installer handles dependency installation for your Linux distribution (Debian/Ubuntu, Fedora, Arch, etc.). If prompted, allow the installation of optional packages like `xterm` for an enhanced experience.

### Usage

After installation, simply run:

```bash
scriptgrab
```

This command launches the interactive Whiptail-based GUI, where you can:

- **Help**: Display usage instructions.
- **List**: View available remote scripts.
- **Install Remote**: Download and install remote scripts using guided input.
- **Install Local**: Install a local script by browsing or entering its path.
- **Manage**: Interactively view, run, or uninstall installed scripts.
- **Remove (rm)**: Uninstall a specific script.
- **Autoremove**: Remove all installed scripts at once.
- **Update**: Upgrade ScriptGrab to the latest version seamlessly.
- **About**: See tool information with cool ASCII art and version details.
- **Exit**: Close the ScriptGrab interface.

Every option is presented via Whiptail dialogs, ensuring a fully graphical and user-friendly experience.

---

## Contributing

We welcome community contributions! To add your script to ScriptGrab:

1. **Fork the repository.**
2. **Upload your `.sh` script** to the `sh` folder in the **main branch**.
3. **Submit a pull request** with a brief description of your script.

Your script will be reviewed and included in a future version of ScriptGrab.

---

## License

This project is licensed under the [GNU GENERAL PUBLIC LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html). See the LICENSE file for details.

---

## Contact

For questions, issues, or suggestions, feel free to open an issue on GitHub or reach out to the repository maintainer.

---

Happy scripting! 🚀
