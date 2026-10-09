#!/bin/bash

overall_status="OK"

echo "================================"
echo "=== Server Health Check ==="
echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================"
echo

echo "=== Disk Usage ==="
disk_usage=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$disk_usage" -ge 80 ]; then
    echo "[WARN] Disk usage is ${disk_usage}%"
    overall_status="WARN"
else
    echo "[OK] Disk usage is ${disk_usage}%"
fi


echo
echo "=== Top CPU Processes ==="
ps -eo pid,user,comm,etimes,%cpu,%mem --sort=-%cpu \
| awk 'NR==1 || ($3!="ps" && $3!="head" && $3!="awk" && $3!="tee")' \
| head

high_cpu_process=$(ps -eo pid,user,comm,etimes,%cpu --no-headers \
| awk '$3!="ps" && $3!="head" && $3!="awk" && $3!="tee" && $4 >= 10 && $5 >= 80 {print; exit}')

if [ -n "$high_cpu_process" ]; then
    echo "[WARN] Persistent high CPU process detected:"
    echo "$high_cpu_process"
    overall_status="WARN"
else
    echo "[OK] No persistent high CPU process detected"
fi

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
if ss -tuln | grep -q ':80'; then
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