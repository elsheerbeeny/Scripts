#!/bin/bash

# Set backup destination (modify as needed)
BACKUP_DIR="/backups/home"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Timestamp for unique filename
timestamp=$(date +%Y%m%d_%H%M%S)

# Create compressed backup archive
tar -czf "$BACKUP_DIR/home_backup_$timestamp.tar.gz" /home

# Rotate backups (keep the latest 5)
find "$BACKUP_DIR" -name "home_backup_*.tar.gz" -mtime +4 -exec rm {} \;

# Notify user of backup completion
echo "Backup of /home completed successfully and saved to $BACKUP_DIR/home_backup_$timestamp.tar.gz"
