#!/bin/bash

# Thresholds for alerting
CPU_THRESHOLD=80     # CPU usage percentage
MEM_THRESHOLD=80     # Memory usage percentage
LATENCY_THRESHOLD=200 # Network latency in ms (can be adjusted based on your requirement)

# Log file for CSV output
LOG_FILE="system_metrics.csv"

# Email settings for alerts
EMAIL_TO="alert_email@example.com"
EMAIL_SUBJECT="System Alert: Performance Threshold Exceeded"

# Initialize log file with headers
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,CPU Usage (%),Memory Usage (%),Network Latency (ms)" >> $LOG_FILE
fi

# Function to send email alert
send_alert() {
    message="$1"
    echo "$message" | mail -s "$EMAIL_SUBJECT" $EMAIL_TO
}

# Function to monitor CPU usage
monitor_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}') # Extract CPU usage
}

# Function to monitor memory usage
monitor_memory() {
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}') # Calculate memory usage percentage
}

# Function to simulate network latency (you can use ping or other real tools)
monitor_network_latency() {
    latency=$(ping -c 1 google.com | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
    latency=${latency:-0}  # Default to 0 ms if no response
}

# Function to log the metrics in CSV format
log_metrics() {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp,$cpu_usage,$mem_usage,$latency" >> $LOG_FILE
}

# Monitoring loop
while true; do
    # Collect metrics
    monitor_cpu
    monitor_memory
    monitor_network_latency

    # Log the collected metrics
    log_metrics

    # Check for threshold violations and send alerts
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        send_alert "CPU usage exceeded: ${cpu_usage}%"
    fi

    if (( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )); then
        send_alert "Memory usage exceeded: ${mem_usage}%"
    fi

    if (( $(echo "$latency > $LATENCY_THRESHOLD" | bc -l) )); then
        send_alert "Network latency exceeded: ${latency} ms"
    fi

    # Wait for 60 seconds before the next check
    sleep 60
done
