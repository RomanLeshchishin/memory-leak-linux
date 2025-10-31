#!/bin/bash

LOG_FILE="/home/roman/Desktop/resource_usage.log"
OOM_LOG="/home/roman/Desktop/oom_events.log"
REPORT_FILE="/home/roman/Desktop/resource_report.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "file not found: $LOG_FILE"
    exit 1
fi

if [ ! -f "$OOM_LOG" ]; then
    echo "file not found: $OOM_LOG"
    exit 1
fi

OOM_COUNT=$(awk '/Oom:/ {flag=1; next} /^Other:|^===/ {flag=0} flag && NF {count++} END {print count+0}' "$OOM_LOG")

if [ "$OOM_COUNT" -eq 0 ]; then
    echo "Not found oom events"
    exit 0
fi

{
    echo "============================"
    echo "ОТЧЁТ ПО РЕСУРСАМ"
    echo "Сгенерировано: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================"
    echo ""

    echo "📊 Использование памяти:"
    echo "Время                          total    used    free    shared  buff/cache  available"
    echo "--------------------------------------------------------------------------"
    awk '/Mem:/ {
        time=strftime("%H:%M:%S");
        printf "%-30s %7s %7s %7s %7s %10s %10s\n",
        time, $2, $3, $4, $5, $6, $7
    }' "$LOG_FILE"
    echo ""

    echo "💻 Использование CPU:"
    echo "Время                          usr   nice   sys  iowait   irq   soft  steal  guest  gnice   idle"
    echo "------------------------------------------------------------------------------------------"
    awk '/Average:/ {
        time=strftime("%H:%M:%S");
        if (NF==12) {
            printf "%-30s %5s %6s %5s %7s %5s %5s %5s %5s %5s %6s\n",
            time, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
        }
    }' "$LOG_FILE"
    echo ""

    echo "🔁 Использование SWAP:"
    echo "Время                          total     used     free"
    echo "----------------------------------------------"
    awk '/Swap:/ {
        time=strftime("%H:%M:%S");
        printf "%-30s %8s %8s %8s\n", time, $2, $3, $4
    }' "$LOG_FILE"
    echo ""

    echo "⚠️  Критические события:"
    echo "------------------------------------------------------"
    grep -i -E "error|fail|critical|warning|Invalid|Timeout|cannot" "$LOG_FILE" || echo "Критических событий не найдено."

    echo ""
    echo "💥 OOM-события ядра:"
    echo "------------------------------------------------------"
    awk '/Oom:/ {flag=1; next} /^Other-core-events:|^===/ {flag=0} flag && NF {print $0}' "$OOM_LOG"

} > "$REPORT_FILE"

echo "✅ Отчёт успешно создан: $REPORT_FILE"
