#!/bin/bash

OOM_LOG="/home/roman/Desktop/oom_events.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "=== Monitoring of core events $TIMESTAMP ====" >> "$OOM_LOG"
echo "" >> "$OOM_LOG"

echo "Oom:" >> "$OOM_LOG"
dmesg | grep -i 'killed process' | tail -n 5 >> "$OOM_LOG"
grep -i 'oom' /var/log/kern.log | tail -n 5 >> "$OOM_LOG"
echo "" >> "$OOM_LOG"

echo "Other:" >> "$OOM_LOG"
grep -i -E 'out of memory|killed|oom' /var/log/syslog | tail -n 5 >> "$OOM_LOG"
echo "" >> "$OOM_LOG"
