# ScriptGrab

**ScriptGrab** is a lightweight and powerful script manager designed to make downloading, managing, and running shell scripts a breeze. With ScriptGrab, you can quickly grab scripts from trusted sources, make them executable, and even uninstall them—all from a single command-line interface.

---

## Features

- **Script Management**: Download and execute scripts effortlessly.
- **Uninstall Functionality**: Remove scripts you no longer need with a simple command.
- **Expandable**: Add your own scripts to the repository for inclusion in future updates.
- **Community Contribution**: Easily contribute your scripts to the project by adding them to the `sh` folder.

---

## Getting Started

### Installation

To install ScriptGrab, run the following command in your terminal:

```bash
wget https://github.com/Rays-Robotics/ScriptGrab/raw/refs/heads/main/install-scriptgrab.sh -O install-scriptgrab.sh
chmod +x install-scriptgrab.sh
./install-scriptgrab.sh
```

### Usage

Run the `scriptgrab.sh` script to start managing your shell scripts:

```bash
./scriptgrab.sh
```

#### Commands

- **`help`**: Display usage instructions.
- **`list`**: Show available scripts.  
  *Note: To add your own script, see the [Contributing](#contributing) section.*
- **`<script>`**: Download and make the specified script executable.
- **`rm <script>`**: Uninstall (remove) the specified script.

---

## Example

1. **List Available Scripts**:
   ```bash
   ./scriptgrab.sh list
   ```
   Output:
   ```
   Available scripts:
     - brave-install

   Want to add your own script? See the GitHub repository!
   Add your .sh script to the 'sh' folder, and it will be included in the next version.
   ```

2. **Install Brave Browser Installer**:
   ```bash
   ./scriptgrab.sh brave-install
   ```
   Output:
   ```
   Downloading and making brave-install executable...
   brave-install has been downloaded and made executable.
   To use it, run: ./brave-install
   ```

3. **Uninstall a Script**:
   ```bash
   ./scriptgrab.sh rm brave-install
   ```
   Output:
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

