#!/bin/bash

overall_status="OK"

echo "================================"
echo "=== Server Health Check ==="
echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================"
echo

echo "=== Disk Usage ==="
df -h /

echo
echo "=== Top CPU Processes ==="
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head

echo
echo "=== nginx Service Status ==="
if systemctl is-active --quiet nginx; then
    echo "[OK] nginx is active"
else
    echo "[WARN] nginx is not active"
    overall_status="WARN"
fi

echo
echo "=== Port 80 Listening ==="
if ss -ltn 'sport = :80' | grep -q LISTEN; then
    echo "[OK] Port 80 is listening"
else
    echo "[WARN] Port 80 is not listening"
    overall_status="WARN"
fi

echo
echo "=== HTTP Response ==="
if curl -s -I http://localhost | grep -q "200 OK"; then
    echo "[OK] Web server returned HTTP 200"
else
    echo "[WARN] Web server did not return HTTP 200"
    overall_status="WARN"
fi

echo
echo "Overall Status: $overall_status"

echo
echo "================================"
echo "=== Health Check Complete ==="
echo "================================"