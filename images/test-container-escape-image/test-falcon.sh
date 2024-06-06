#!/bin/bash

# Trigger Detect Malicious Scripts rule
echo "Running curl to trigger Detect Malicious Scripts rule"
curl http://example.com

# Trigger Detect Container Escape Attempt rule
echo "Attempting to read /etc/shadow to trigger Detect Container Escape Attempt rule"
cat /etc/shadow

# Trigger Detect Malware Activity rule
echo "Creating /tmp/malicious to trigger Detect Malware Activity rule"
touch /tmp/malicious

# Keep the container running
tail -f /dev/null
