# Script to install and configure sunshine for systemd on Arch Linux tested on cachyOS

# Add LizardByte repository to /etc/pacman.conf (requires root)
# This allows installing sunshine from the LizardByte repository.

# Update package lists using pacman (requires root)
# This ensures that pacman has the latest package information,
# including the newly added LizardByte repository.

# Install sunshine if it's not already installed (requires root)
# Checks if the 'sunshine' command exists. If not, it installs it.

# Configuration variables
# Path where the sunshine wrapper script will be installed
# Name of the systemd service
# Path to the systemd service file

# Dynamically get the current user
# Gets the username of the user running the script

# Target sunshine version (extracted using grep)
# This extracts the version number from the sunshine executable's filename.
# For example, if /usr/bin/sunshine-0.23.1 exists, it will extract "0.23.1".

# Check if the target version could be determined. Abort if not.

# Versioned executable and path variables
# Constructs the full name and path of the versioned executable

# Sunshine script content (embedded)
# This is the script that will be installed as archSunshine.sh.
# It sets the necessary permissions and capabilities for sunshine.

# Replace the target version placeholder in the script content
# This ensures the embedded script uses the correct sunshine version.

# Create/Overwrite the sunshine script (requires root)
# This creates or overwrites the archSunshine.sh script in /usr/local/bin.

# Make the sunshine script executable (requires root)

# Create the systemd service file (requires root)
# This creates the systemd service file that will run archSunshine.sh at boot.

# Enable the systemd service (requires root)
# This enables the service to start at boot.

# Start the service immediately (optional, only if the --start argument is provided)
# This starts the service without requiring a reboot.

# Success message

# Exit code
