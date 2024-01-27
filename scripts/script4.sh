#!/bin/bash

# Get directory path from user
read -p "Enter the directory to analyze: " directory

# Check if directory exists
if [[ ! -d "$directory" ]]; then
  echo "Error: Directory not found."
  exit 1
fi

# Function to analyze a file using appropriate tools
analyze_file() {
  local file_path="$1"
  local file_type=$(file -b "$file_path")

  case "$file_type" in
    "image/jpeg" | "image/png" | "image/gif" | "image/bmp")
      exiftool "$file_path"
      ;;
    "audio/mpeg" | "audio/mp4" | "video/mp4" | "video/x-matroska")
      mediainfo "$file_path"
      ;;
    "text/plain" | "application/octet-stream")
      strings "$file_path"
      ;;
    "tcpdump capture file (little-endian)" | "tcpdump capture file (big-endian)")
      tcpdump -r "$file_path"
      ;;
    *)
      echo "Unsupported file type: $file_type"
      ;;
  esac
}

# Iterate through files in the directory
for file in "$directory"/*; do
  if [[ -f "$file" ]]; then
    echo "----------------------------------------"
    echo "Analyzing file: $file"
    analyze_file "$file"
  fi
done
