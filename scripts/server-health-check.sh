#!/bin/bash

echo "=== Disk Usage ==="
df -h

echo
echo "=== Top CPU Processes ==="
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head

echo
echo "=== nginx Service Status ==="
if systemctl is-active --quiet nginx; then
    echo "[OK] nginx is active"
else
    echo "[WARN] nginx is not active"
fi

echo
echo "=== Port 80 Listening ==="
if ss -tuln | grep -q ':80'; then
    echo "[OK] Port 80 is listening"
else
    echo "[WARN] Port 80 is not listening"
fi

echo
echo "=== HTTP Response ==="
if curl -s -I http://localhost | grep -q "200 OK"; then
    echo "[OK] Web server returned HTTP 200"
else
    echo "[WARN] Web server did not return HTTP 200"
fi