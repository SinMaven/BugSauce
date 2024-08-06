#!/bin/bash

# Ensure the script is run as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Install OpenSSH Server
echo "Installing OpenSSH Server..."
apt update
apt install -y openssh-server

# Start and enable the SSH service
echo "Starting and enabling SSH service..."
systemctl start ssh
systemctl enable ssh

# Allow SSH through the firewall
echo "Configuring firewall to allow SSH..."
ufw allow ssh

# Display the SSH service status
echo "Checking SSH service status..."
systemctl status ssh

# Display the machine's IP address
echo "Your machine's IP address is:"
hostname -I
