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
