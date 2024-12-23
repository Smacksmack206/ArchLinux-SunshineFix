#!/bin/bash

# Script to install and configure sunshine for systemd on Arch Linux

# Add LizardByte repository (requires root)
sudo sh -c 'echo "[lizardbyte]
SigLevel = Optional
Server = https://github.com/LizardByte/pacman-repo/releases/latest/download" >> /etc/pacman.conf' || {
  echo "Warning: Failed to add LizardByte repository to pacman.conf. Please add it manually if needed." >&2
}

# Update package lists
sudo pacman -Syu --noconfirm || {
    echo "Error: Failed to update package lists." >&2
    exit 1
}

# Install sunshine (if not already installed)
if ! command -v sunshine &>/dev/null; then
    sudo pacman -S sunshine --noconfirm || {
        echo "Error: Failed to install sunshine. Aborting." >&2
        exit 1
    }
fi

# Configuration
script_destination="/usr/local/bin/archSunshine.sh"
service_name="archSunshine.service"
service_file="/etc/systemd/system/${service_name}"

# Dynamically get the current user
user_to_run=$(whoami)

# Target sunshine version (extracted using grep)
target_version=$(ls /usr/bin/sunshine-* 2>/dev/null | grep -oP '(?<=sunshine-)[0-9.]+' || true)

if [[ -z "$target_version" ]]; then
    echo "Error: Could not determine sunshine version. Aborting." >&2
    exit 1
fi

versioned_executable="sunshine-${target_version}"
versioned_path="/usr/bin/${versioned_executable}"

# Sunshine script content (embedded)
script_content="#!/bin/bash

target_dir=\"/usr/bin\"
executable=\"sunshine\"
versioned_executable=\"\${executable}-${target_version}\"

cd \"\${target_dir}\" || {
  echo \"Error: Could not change directory to \${target_dir}\" >&2
  exit 1
}

sudo chmod a+x \"\${versioned_executable}\"
sudo chmod a+x \"\${executable}\"

if ! sudo setcap cap_sys_admin+p \"\${versioned_executable}\"; then
  echo \"Error: Failed to set capabilities on \${versioned_executable}\" >&2
  exit 1
fi

echo \"Permissions and capabilities set successfully.\"
"

# Replace the target version in the script content
script_content=$(echo "$script_content" | sed "s/\${target_version}/${target_version}/g")

# Create/Overwrite the sunshine script
echo "${script_content}" | sudo tee "${script_destination}" > /dev/null || {
    echo "Error: Failed to create/update sunshine script" >&2
    exit 1
}

# Make the script executable
sudo chmod +x "${script_destination}" || {
  echo "Error: Failed to make script executable" >&2
  exit 1
}

# Create the systemd service file
cat << EOF | sudo tee "${service_file}" > /dev/null
[Unit]
Description=Sunshine Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=${script_destination}
User=${user_to_run}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

if [[ $? -ne 0 ]]; then
    echo "Error: Failed to write service file" >&2
    exit 1
fi

# Enable the service
sudo systemctl enable "${service_name}" || {
  echo "Error: Failed to enable service" >&2
  exit 1
}

# Start the service (optional)
if [[ "$1" == "--start" ]]; then
    sudo systemctl start "${service_name}" || {
        echo "Error: Failed to start service" >&2
        exit 1
    }
fi

echo "Sunshine installed and configured successfully."

exit 0
