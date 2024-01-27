#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file_path>"
  exit 1
fi

file_path=$1

if [[ ! -f "$file_path" ]]; then
  echo "Error: File not found."
  exit 1
fi

# Get file information
file_size=$(stat -c %s "$file_path")
file_type=$(file -b "$file_path")
file_permissions=$(stat -c %A "$file_path")

# Display information in a clear format
echo "File Information:"
echo "  Path: $file_path"
echo "  Size: $file_size bytes"
echo "  Type: $file_type"
echo "  Permissions: $file_permissions"
