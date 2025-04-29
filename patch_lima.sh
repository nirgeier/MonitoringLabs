#!/bin/bash

# Lima Home Directory Mount Patcher
# This script patches the Lima configuration to ensure the home directory is mounted with write permissions

set -e

# Default Lima instance name
INSTANCE_NAME="default"

# Parse arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -n|--name)
      INSTANCE_NAME="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-n|--name INSTANCE_NAME]"
      echo "  -n, --name  Specify Lima instance name (default: default)"
      echo "  -h, --help  Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

LIMA_CONFIG_DIR="$HOME/.lima/$INSTANCE_NAME"
LIMA_CONFIG_FILE="$LIMA_CONFIG_DIR/lima.yaml"

# Check if Lima is installed
if ! command -v limactl &> /dev/null; then
    echo "Error: limactl command not found. Please install Lima first."
    exit 1
fi

# Check if the instance exists
if [ ! -d "$LIMA_CONFIG_DIR" ]; then
    echo "Error: Lima instance '$INSTANCE_NAME' does not exist."
    echo "Available instances:"
    limactl list
    exit 1
fi

# Check if the config file exists
if [ ! -f "$LIMA_CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $LIMA_CONFIG_FILE"
    exit 1
fi

# Create a backup of the original config
BACKUP_FILE="$LIMA_CONFIG_FILE.backup-$(date +%Y%m%d%H%M%S)"
cp "$LIMA_CONFIG_FILE" "$BACKUP_FILE"
echo "Created backup at $BACKUP_FILE"

# Check if the instance is running
if limactl list | grep -q "$INSTANCE_NAME.*Running"; then
    echo "Stopping Lima instance '$INSTANCE_NAME'..."
    limactl stop "$INSTANCE_NAME"
fi

# Function to check if home mount already exists
has_home_mount() {
    grep -q "location: \"~\"" "$LIMA_CONFIG_FILE" || grep -q "location: $HOME" "$LIMA_CONFIG_FILE"
}

# Add or update home mount configuration
if has_home_mount; then
    echo "Home directory mount already exists. Ensuring it's writable..."
    # Use sed to update the writable flag
    # This is a simplified approach - it may need adjustments for complex configs
    
    # Find the line number where the home mount starts
    HOME_MOUNT_LINE=$(grep -n "location: \"~\"\\|location: $HOME" "$LIMA_CONFIG_FILE" | cut -d: -f1)
    
    if [ -n "$HOME_MOUNT_LINE" ]; then
        # Check if writable is set in the next few lines
        WRITABLE_LINE=$(tail -n +$HOME_MOUNT_LINE "$LIMA_CONFIG_FILE" | grep -n "writable:" | head -n 1 | cut -d: -f1)
        
        if [ -n "$WRITABLE_LINE" ]; then
            # Calculate the actual line number
            ACTUAL_LINE=$((HOME_MOUNT_LINE + WRITABLE_LINE - 1))
            # Replace the writable line
            sed -i.tmp "${ACTUAL_LINE}s/writable:.*/writable: true/" "$LIMA_CONFIG_FILE"
        else
            # Add writable after the location line
            sed -i.tmp "${HOME_MOUNT_LINE}a\\  writable: true" "$LIMA_CONFIG_FILE"
        fi
        rm -f "$LIMA_CONFIG_FILE.tmp"
    fi
else
    echo "Adding home directory mount configuration..."
    
    # Check if mounts section exists
    if grep -q "^mounts:" "$LIMA_CONFIG_FILE"; then
        # Append to existing mounts section
        HOME_MOUNT_CONFIG="  - location: \"~\"\n    writable: true\n    sshfs:\n      cache: true\n      followSymlinks: true"
        # Find the line where mounts section starts
        MOUNTS_LINE=$(grep -n "^mounts:" "$LIMA_CONFIG_FILE" | cut -d: -f1)
        
        # Insert after the mounts line
        sed -i.tmp "${MOUNTS_LINE}a\\${HOME_MOUNT_CONFIG}" "$LIMA_CONFIG_FILE"
        rm -f "$LIMA_CONFIG_FILE.tmp"
    else
        # Add new mounts section
        echo -e "\n# Home directory mount added by script\nmounts:\n  - location: \"~\"\n    writable: true\n    sshfs:\n      cache: true\n      followSymlinks: true" >> "$LIMA_CONFIG_FILE"
    fi
fi

echo "Configuration update complete."
echo "Starting Lima instance '$INSTANCE_NAME'..."
limactl start "$INSTANCE_NAME"

echo -e "\nSuccess! Your Lima instance now has the home directory mounted with write permissions."
echo "You can verify by running: limactl shell $INSTANCE_NAME 'touch ~/lima_test_file && echo Success || echo Failed'"