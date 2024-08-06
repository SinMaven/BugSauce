#!/bin/bash

# Print connection info
echo "=== Connection Info ==="
echo "Hostname: $(hostname)"
echo "IP Address: $(hostname -I | awk '{print $1}')"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo "Uptime:"
uptime
echo "Disk Usage:"
df -h
echo "Memory Usage:"
free -h

# Start a simple HTTP server on port 8080
echo "Starting HTTP server on port 8080..."
python3 -m http.server 8080
