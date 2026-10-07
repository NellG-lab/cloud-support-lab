#!/bin/bash

echo "=== Disk Usage ==="
df -h

echo
echo "=== Top CPU Processes ==="
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head

echo
echo "=== nginx Service Status ==="
systemctl is-active nginx

echo
echo "=== Port 80 Listening ==="
ss -tuln | grep ':80'

echo
echo "=== HTTP Response ==="
curl -I http://localhost