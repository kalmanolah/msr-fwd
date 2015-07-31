#!/bin/bash

CONFIGURATION_PATH="/usr/local/etc/msr-fwd.cfg"

if [ ! -f "$CONFIGURATION_PATH" ]; then
    echo "Magnetic Stripe Reader Forwarder configuration not found at $CONFIGURATION_PATH"
    exit 1
fi

# Change working directory to script directory
cd "$(dirname "$0")"

# Include configuration
. $CONFIGURATION_PATH

# Set default values for configuration
: ${MSR_CLI_PATH:="/usr/local/bin/msr-cli"}
: ${HTTP_ENDPOINT:="http://localhost"}
: ${DEVICE_VENDOR_ID:="0x03f0"}
: ${DEVICE_PRODUCT_ID:="0x2724"}

if [ ! -f "$MSR_CLI_PATH" ]; then
    echo "MSR CLI not found at $MSR_CLI_PATH"
    exit 1
fi

# Detect python/cURL
PYTHON_PATH=$(which python)
CURL_PATH=$(which curl)

if [[ -z "$PYTHON_PATH" ]]; then
    echo "Python not found"
    exit 1
fi

if [[ -z "$CURL_PATH" ]]; then
    echo "cURL not found"
    exit 1
fi

while read -r line
do
    # Attempt to forward data
    $CURL_PATH -s -f -i -X POST -d "$line" "$HTTP_ENDPOINT" --show-error -o /dev/null

    if [ $? -eq 0 ]; then
        echo "Successfully forwarded ${#line} bytes to $HTTP_ENDPOINT"
    else
        echo "Failed to forward ${#line} bytes to $HTTP_ENDPOINT: ${line}"
    fi
done < <($MSR_CLI_PATH -dvid "$DEVICE_VENDOR_ID" -dpid "$DEVICE_PRODUCT_ID")
