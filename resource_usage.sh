#!/bin/bash
LOG_FILE="/home/roman/Desktop/resource_usage.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "=== Monitoring resources: $TIMESTAMP ====" >> "$LOG_FILE"
echo "Memory:" >> "$LOG_FILE"
free -h | awk 'NR==1 || /^Mem:/' >> "$LOG_FILE"
echo "Used memory: $(free | awk '/Mem:/ {printf "%.1f", ($3/$2 * 100)}')%" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "CPU:" >> "$LOG_FILE"
mpstat 1 1 >> "$LOG_FILE" 
echo "CPU usage: $(mpstat 1 1 | awk '/Average:/ {printf "%.1f", (100 - $12)}')%" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "SWAP:" >> "$LOG_FILE"
free | grep Swap >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Critical events:" >> "$LOG_FILE"
grep -i -E 'emerg|alert|crit|error' /var/log/syslog | tail -n 5 >> $LOG_FILE
echo "" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
