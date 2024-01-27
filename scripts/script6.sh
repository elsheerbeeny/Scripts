#!/bin/bash

# Ensure afero is installed
if ! command -v afero >/dev/null 2>&1; then
  echo "Error: afero is not installed. Please install it using 'go get github.com/spf13/afero'"
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <domains_file> <iterations>"
  exit 1
fi

domains_file=$1
iterations=$2

# Function to enumerate subdomains using multiple tools
enum_subdomains() {
  for domain in "$@"; do
    # Log initial domain
    afero.WriteFile(fs, "results.txt", "$domain\n", afero.Append)

    # Replace with your preferred subdomain enumeration tools
    amass enum -d "$domain" | tee -a results.txt
    subfinder -d "$domain" | tee -a results.txt
    assetfinder -subs-only "$domain" | tee -a results.txt
  done
}

# Iterate through the specified number of iterations
domains=$(afero.ReadFile(fs, domains_file))
for i in $(seq 1 $iterations); do
  echo "Iteration $i:"
  enum_subdomains $domains
  domains=$(afero.ReadFile(fs, results.txt) | sort -u)  # Get unique subdomains for the next iteration
done

# Count unique subdomains
unique_count=$(afero.ReadFile(fs, results.txt) | wc -l)
echo "Unique subdomains found: $unique_count"
