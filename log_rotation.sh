#!/bin/bash

LOG_DIR="/var/log/mysql"      # Directory where logs are stored
ARCHIVE_DIR="/var/log/myapp/archive"  # Directory where logs will be archived
ARCHIVE_DAYS=7               # Number of days after which logs will be archived
DELETE_DAYS=30               # Number of days after which archived logs will be deleted

# Create archive directory if it doesn't exist
if [ ! -d "$ARCHIVE_DIR" ]; then
  mkdir -p "$ARCHIVE_DIR"
fi

# Get current date
DATE=$(date +"%Y-%m-%d")

# Rotate logs: move logs to the archive directory that are older than ARCHIVE_DAYS
find "$LOG_DIR" -type f -name "*.log" -mtime +$ARCHIVE_DAYS -exec mv {} "$ARCHIVE_DIR/{}-$DATE" \;

# Log message for rotated files
echo "Archived logs older than $ARCHIVE_DAYS days from $LOG_DIR to $ARCHIVE_DIR."

# Delete logs in the archive directory older than DELETE_DAYS
find "$ARCHIVE_DIR" -type f -name "*.log-*" -mtime +$DELETE_DAYS -exec rm {} \;

# Log message for deleted files
echo "Deleted archived logs older than $DELETE_DAYS days from $ARCHIVE_DIR."

# Exit
echo "Log rotation completed successfully."