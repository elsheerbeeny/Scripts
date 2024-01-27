#!/bin/bash

set -o errexit  # Exit on errors
set -o verbose  # Enable verbosity

# 1. Connect using Warp
echo "Connecting to Warp..."
warp-cli connect

# Check for IP assignment
echo "Checking Warp IP assignment..."
if [[ $(curl -s https://api.ipify.org) ]]; then
  echo "Warp IP assigned: $(curl -s https://api.ipify.org)"
else
  echo "Warp IP assignment failed. Exiting."
  exit 1
fi

# 2. Connect using OpenVPN (background process)
echo "Connecting to OpenVPN..."
openvpn --config your_openvpn_config.ovpn &

# Wait for OpenVPN connection
echo "Waiting for OpenVPN connection..."
sleep 10  # Adjust wait time as needed

# Check for IP assignment
echo "Checking OpenVPN IP assignment..."
if [[ $(curl -s https://api.ipify.org) ]]; then
  echo "OpenVPN IP assigned: $(curl -s https://api.ipify.org)"
else
  echo "OpenVPN IP assignment failed. Exiting."
  kill %1  # Terminate background OpenVPN process
  exit 1
fi

# 3. Second check (ping)
echo "Performing second check (ping 10.10.10.10)..."
ping -c 3 10.10.10.10

# 4. Disconnect from Warp
echo "Disconnecting from Warp..."
warp-cli disconnect
