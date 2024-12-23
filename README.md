# Sunshine Installation and Configuration Script for Arch Linux (tested on CachyOS)

This script automates the installation and configuration of Sunshine on Arch Linux, including setting necessary permissions, capabilities, and creating a systemd service for automatic startup at boot.

## Features

*   Adds the LizardByte repository to `/etc/pacman.conf` (optional, with a warning if it fails).
*   Updates package lists using `pacman`.
*   Installs Sunshine if it's not already present.
*   Dynamically detects the installed Sunshine version.
*   Creates a wrapper script (`archSunshine.sh`) in `/usr/local/bin` to manage permissions and capabilities.
*   Sets appropriate permissions and the `cap_sys_admin` capability for Sunshine.
*   Creates a systemd service (`archSunshine.service`) to ensure Sunshine starts at boot.
*   Option to start the service immediately after installation using the `--start` flag.
*   Comprehensive error handling for robust execution.

## Prerequisites

*   Arch Linux installed and configured.
*   `sudo` privileges.

## Installation

1.  **Download the script:** Download the `install-sunshine.sh` script.
2.  **Make it executable:**

    ```bash
    chmod +x install-sunshine.sh
    ```

3.  **Run the script with `sudo`:**

    ```bash
    sudo ./install-sunshine.sh
    ```

    To also start the service immediately after installation:

    ```bash
    sudo ./install-sunshine.sh --start
    ```

## Script Breakdown

The script performs the following steps:

1.  **Add LizardByte Repository (Optional):**
    *   Adds the LizardByte repository to `/etc/pacman.conf` to enable installation of Sunshine.
    *   If the repository is already present or adding it fails, a warning is displayed, but the script continues.

2.  **Update Package Lists:**
    *   Runs `pacman -Syu --noconfirm` to update the local package database and synchronize with remote repositories.

3.  **Install Sunshine:**
    *   Checks if Sunshine is already installed.
    *   If not installed, attempts to install it using `pacman -S sunshine --noconfirm`.
    *   If the installation fails, the script aborts.

4.  **Configuration:**
    *   Sets variables for the script destination, service name, and service file path.
    *   Dynamically retrieves the current user's username.
    *   Dynamically extracts the installed Sunshine version from the executable filename.
    *   Constructs the full path to the versioned Sunshine executable.

5.  **Create Wrapper Script (`archSunshine.sh`):**
    *   Creates a wrapper script at `/usr/local/bin/archSunshine.sh`.
    *   This script sets the necessary permissions (`a+x`) and the `cap_sys_admin` capability for the Sunshine executable.
    *   Uses `sed` to correctly insert the version into the script.

6.  **Create Systemd Service (`archSunshine.service`):**
    *   Creates a systemd service file at `/etc/systemd/system/archSunshine.service`.
    *   This service ensures that the `archSunshine.sh` script is executed at boot.
    *   Configured to run as the current user.

7.  **Enable Systemd Service:**
    *   Enables the systemd service to start automatically at boot.

8.  **Start Service (Optional):**
    *   If the `--start` flag is provided, the script starts the service immediately.

## Troubleshooting

*   **Repository Issues:** If you encounter issues adding the LizardByte repository, you can add it manually by editing `/etc/pacman.conf`.
*   **Sunshine Installation Issues:** Check your internet connection and ensure the LizardByte repository is working correctly.
*   **Service Startup Issues:** Check the systemd service status using `systemctl status archSunshine.service` for any error messages.
*   **Permissions Issues:** Ensure the `archSunshine.sh` script has execute permissions (`chmod +x /usr/local/bin/archSunshine.sh`).

## Uninstallation

To uninstall, you'll need to manually perform the following steps:

1. Stop the service: `sudo systemctl stop archSunshine.service`
2. Disable the service: `sudo systemctl disable archSunshine.service`
3. Remove the service file: `sudo rm /etc/systemd/system/archSunshine.service`
4. Remove the wrapper script: `sudo rm /usr/local/bin/archSunshine.sh`
5. (Optional) Remove sunshine: `sudo pacman -R sunshine`
6. (Optional) Remove the Lizardbyte repository from `/etc/pacman.conf`

## License

This script is licensed under the GNU General Public License v3.0.
