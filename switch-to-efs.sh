#!/bin/bash
#
# This script automates mounting an EFS file system on Amazon Linux
# and migrates data from /data.
#
# Variables:
#
EFS_ID="fs-0f680c17e4a4aae87" # Replace with your EFS file system ID
MOUNT_POINT="/mnt/efs"
DATA_DIR="/data"
#
# Functions:
#
function log_message() {
  local message="$1"
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $message"
}
#
# Check if EFS ID is set
if [ -z "$EFS_ID" ]; then
  log_message "Error: EFS_ID is not set. Please edit the script and provide your EFS file system ID."
  exit 1
fi
#
# 1. Install amazon-efs-utils
log_message "Installing amazon-efs-utils..."
sudo yum install -y amazon-efs-utils
if [ $? -ne 0 ]; then
  log_message "Error: Failed to install amazon-efs-utils."
  exit 1
fi
#
# 2. Create mount point
log_message "Creating mount point: $MOUNT_POINT"
sudo mkdir -p "$MOUNT_POINT"
if [ $? -ne 0 ]; then
  log_message "Error: Failed to create mount point."
  exit 1
fi
#
# 3. Mount the EFS file system
log_message "Mounting EFS file system: $EFS_ID to $MOUNT_POINT"
sudo mount -t efs "${EFS_ID}:/" "$MOUNT_POINT"
if [ $? -ne 0 ]; then
  log_message "Error: Failed to mount EFS file system. Check EFS ID and network configuration."
  exit 1
fi
#
# 4. Add EFS entry to /etc/fstab for persistent mounting
log_message "Adding EFS entry to /etc/fstab..."
sudo tee -a /etc/fstab <<< "${EFS_ID}:/ $MOUNT_POINT efs defaults,_netdev 0 0"
if [ $? -ne 0 ]; then
  log_message "Error: Failed to add entry to /etc/fstab.  Manual configuration of /etc/fstab may be required."
  # Continue, but with a warning
fi
#
# 5. Migrate data from /data to EFS
if [ -d "$DATA_DIR" ]; then #check if the directory exists
    log_message "Copying data from $DATA_DIR to $MOUNT_POINT"
    sudo cp -r "$DATA_DIR"/* "$MOUNT_POINT"/
    if [ $? -ne 0 ]; then
      log_message "Error: Failed to copy data to EFS."
      exit 1
    fi

    # 6. Remove original data in /data
    log_message "Removing original data from $DATA_DIR"
    sudo rm -rf "$DATA_DIR"/*
    if [ $? -ne 0 ]; then
      log_message "Error: Failed to remove original data from $DATA_DIR."
      exit 1
    fi

    # 7. Unmount /data
    log_message "Unmounting $DATA_DIR"
    sudo umount "$DATA_DIR"
    if [ $? -ne 0 ]; then
      log_message "Error: Failed to unmount $DATA_DIR."
      exit 1
    fi

    # 8. Remove /data
    log_message "Removing $DATA_DIR"
    sudo rm -rf "$DATA_DIR"
    if [ $? -ne 0 ]; then
      log_message "Error: Failed to remove $DATA_DIR."
      exit 1
    fi
fi
#
# 9. Create a symbolic link
log_message "Creating symbolic link from $MOUNT_POINT to $DATA_DIR"
sudo ln -s "$MOUNT_POINT" "$DATA_DIR"
if [ $? -ne 0 ]; then
  log_message "Error: Failed to create symbolic link."
  exit 1
fi
#
log_message "EFS mount and data migration complete."
exit 0
