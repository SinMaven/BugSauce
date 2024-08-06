#!/bin/bash

echo "=== System Information ==="
echo "CPU Information:"
lscpu
echo ""

echo "Memory Information:"
free -h
echo ""

echo "Disk Usage:"
df -h
echo ""

echo "Detailed Disk Usage:"
du -h --max-depth=1
echo ""

echo "OS Information:"
uname -a
echo ""

echo "Distribution Information:"
cat /etc/*release
echo ""

echo "System Uptime:"
uptime
echo ""

echo "Kernel Version:"
uname -r
echo ""

echo "=== Network Information ==="
echo "IP Address:"
hostname -I
echo ""

echo "Network Interfaces:"
ip a
echo ""

echo "Routing Table:"
ip route
echo ""

echo "Active Network Connections:"
netstat -tulnp
echo ""

echo "Listening Ports:"
ss -tuln
echo ""

echo "DNS Server Information:"
cat /etc/resolv.conf
echo ""

echo "Public IP Address:"
curl -s ifconfig.me
echo ""

echo "=== Hardware Information ==="
echo "Block Devices:"
lsblk
echo ""

echo "USB Devices:"
lsusb
echo ""

echo "PCI Devices:"
lspci
echo ""

echo "Sensors Information:"
if command -v sensors &> /dev/null
then
    sensors
else
    echo "lm-sensors not installed."
fi
echo ""

echo "=== User Information ==="
echo "Current Users Logged In:"
w
echo ""

echo "Last Logins:"
last
echo ""

echo "User Information:"
id
echo ""

echo "=== Security Information ==="
echo "Open Files:"
lsof
echo ""

echo "Running Processes:"
ps aux
echo ""

echo "Installed Packages:"
if command -v dpkg &> /dev/null
then
    dpkg -l
elif command -v rpm &> /dev/null
then
    rpm -qa
else
    echo "Package manager not recognized."
fi
echo ""
