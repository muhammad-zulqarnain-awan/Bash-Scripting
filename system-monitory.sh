#!/bin/bash

# Filter out the CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Filter out the Memory Usage
MEM_USAGE=$(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')

# Filter out the Disk Usage
DISK_USAGE=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')

# Create a log file in current working directory
LOGFILE="$(pwd)/system_monitor.log"

# Threshold
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Check whether the system exceed the current threshold or not
if [[ $(echo $CPU_USAGE > $CPU_THRESHOLD |bc -l) ]]
then
    echo "CPU Usage is above threshold"
fi

if [[ $(echo $MEM_USAGE > $MEM_THRESHOLD |bc -l) ]]
then
    echo "Memory Usage is above threshold"
fi

if [[ $(echo $DISK_USAGE > $DISK_THRESHOLD |bc -l) ]]
then
    echo "Disk Usage is above threshold"
fi

# Save the following data in the log file for future use
echo "$(date): CPU: $CPU_USAGE%, Memory: $MEM_USAGE%, Disk: $DISK_USAGE%" >> $LOGFILE

