# ScriptGrab

> **Warning:** This is an **experimental beta branch**  
> **Bugs may be present.** If you prefer a stable experience without potential glitches switch to the [main branch](https://github.com/Rays-Robotics/ScriptGrab) which only includes the CLI version.  
>
> 
**ScriptGrab** is a lightweight and powerful script manager designed to make downloading, managing, and running shell scripts a breeze. With ScriptGrab, you can quickly grab scripts from trusted sources, install local scripts, display tool information, and even uninstall or update them—all from a single command-line interface.

---

## Features

- **Script Management**: Download and execute remote scripts effortlessly.
- **Local Script Installation**: Install local shell scripts directly using the `local` command.
- **About Command**: Display tool information with stylized ASCII art and version details using the `about` command.
- **Update Functionality**: Easily update ScriptGrab to the latest version by running `scriptgrab update`. If you're on an older version, simply run this command to get the new features.
- **Uninstall Functionality**: Remove scripts you no longer need with a simple command.
- **Expandable**: Add your own scripts to the repository for inclusion in future updates.
- **Community Contribution**: Easily contribute your scripts to the project by adding them to the `sh` folder.

---

## Getting Started

### Installation

To install ScriptGrab, run the following commands in your terminal:

```bash
wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/install-scriptgrab.sh -O install-scriptgrab.sh
chmod +x install-scriptgrab.sh
./install-scriptgrab.sh
```

### Usage

Run the `scriptgrab` command to start managing your shell scripts:

```bash
scriptgrab
```

#### Commands

- **`help`**: Display usage instructions.
- **`list`**: Show available remote scripts.  
  *Note: To add your own script, see the [Contributing](#contributing) section.*
- **`local <file>`**: Install a local `.sh` script from the specified file path.
- **`about`**: Show ScriptGrab version information and a fun ASCII art display.
- **`<script>`**: Download and install the specified remote script, making it executable.
- **`rm <script>`**: Uninstall (remove) the specified script.
- **`update`**: Update ScriptGrab to the latest version. If you're running an older version, simply run this command to upgrade.

---

## Example

1. **List Available Scripts**:
   ```bash
   scriptgrab list
   ```
   _Output:_
   ```
   Available scripts:
     - brave-install
     - disk-usage-checker

   Want to add your own script? See the GitHub repository!
   Add your .sh script to the 'sh' folder, and it will be included in the next version.
   ```

2. **Install a Local Script**:
   ```bash
   scriptgrab local /path/to/your/script.sh
   ```
   _Description:_ This command copies your local `.sh` file into the ScriptGrab directory, makes it executable, and allows you to run it from anywhere.

3. **Display About Information**:
   ```bash
   scriptgrab about
   ```
   _Description:_ This command displays a cool ASCII art along with the current ScriptGrab version (v2.1).

4. **(Example) Install Brave Browser Installer**:
   ```bash
   scriptgrab brave-install
   ```
   _Output:_
   ```
   Downloading and installing brave-install...
   brave-install has been installed successfully.
   You can now run it from anywhere using: brave-install
   ```

5. **Update ScriptGrab**:
   If you're on an older version of ScriptGrab, simply run:
   ```bash
   scriptgrab update
   ```
   _Description:_ This command downloads and installs ScriptGrab v2.1 with all the new features.

6. **Uninstall a Script**:
   ```bash
   scriptgrab rm brave-install
   ```
   _Output:_
   ```
   Are you sure you want to uninstall 'brave-install'? (y/n): y
   'brave-install' has been removed.
   ```

---

## Contributing

We welcome contributions from the community! To add your script to ScriptGrab:

1. Fork the repository.
2. Add your `.sh` script to the `sh` folder.
3. Submit a pull request with a brief description of your script.

Your script will be reviewed and included in the next version of ScriptGrab.

---

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for details.

---

## Contact

For questions, issues, or suggestions, feel free to open an issue on GitHub or reach out to the repository maintainer.

---

Happy scripting! 🚀
