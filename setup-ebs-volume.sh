#!/bin/bash

# Format the volume
echo "Formatting /dev/xvdb with XFS filesystem..."
sudo mkfs.xfs /dev/xvdb

# Create mount point
echo "Creating /data directory..."
sudo mkdir -p /data

# Mount the volume
echo "Mounting /dev/xvdb to /data..."
sudo mount /dev/xvdb /data

# Make the mount persistent in /etc/fstab
echo "Updating /etc/fstab for persistence..."
sudo bash -c 'echo "/dev/xvdb /data xfs defaults,nofail 0 2" >> /etc/fstab'

# Change ownership to ec2-user
echo "Setting ownership of /data to ec2-user..."
sudo chown ec2-user:ec2-user /data

# Create files with sample content
cd /data || exit

echo "Creating sample text files..."
echo "This is the content of file 1. Created on $(date)" > file1
echo "Welcome to file 2. This file was created in the data volume." > file2
echo "Welcome to file 3. This file was created for you in the data volume." > file3
echo "This is file 1. I know that's obvious — this was created on $(date)" > file4

# Verify results
echo "Listing created files:"
ls -l /data
