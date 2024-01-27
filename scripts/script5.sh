#!/bin/bash

# Function to generate a random password with specified complexity
generate_password() {
  local length=$1
  local include_lowercase=$2
  local include_uppercase=$3
  local include_numbers=$4
  local include_symbols=$5

  local charset="${include_lowercase:+abcdefghijklmnopqrstuvwxyz}"
  charset="${include_uppercase:+${charset}ABCDEFGHIJKLMNOPQRSTUVWXYZ}"
  charset="${include_numbers:+${charset}0123456789}"
  charset="${include_symbols:+${charset}!@#$%^&*()_+-=[]{}|;':\",.<>?}"

  if [[ -z "$charset" ]]; then
    echo "Error: At least one character type must be included."
    return 1
  fi

  local password=""
  while [[ ${#password} -lt $length ]]; do
    local char=$(shuf -n1 -e "$charset")
    password="${password}${char}"
  done

  echo "$password"
}

# Parse command-line arguments
while getopts "l:u:n:s:" opt; do
  case $opt in
    l) length=$OPTARG ;;
    u) include_lowercase=true ;;
    n) include_numbers=true ;;
    s) include_symbols=true ;;
    *) echo "Usage: $0 [-l length] [-u] [-n] [-s]" >&2
       exit 1 ;;
  esac
done

# Generate password with default complexity if no options are provided
if [[ -z "$length" ]]; then
  length=12
  include_lowercase=true
  include_uppercase=true
  include_numbers=true
  include_symbols=true
fi

# Generate and display the password
password=$(generate_password "$length" "$include_lowercase" "$include_uppercase" "$include_numbers" "$include_symbols")
echo "Generated password: $password"
