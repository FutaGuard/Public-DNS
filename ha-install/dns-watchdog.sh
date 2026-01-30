#!/bin/bash

DOH_URL="http://127.0.0.1/dns-query"
TEST_DOMAIN="google.com"
FAIL_THRESHOLD=3
LOG_FILE="/var/log/dns-watchdog.log"


log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

check_dns() {
    # Use 'q' for DNS over HTTPS query
    # q [name] @[server-url]
    if command -v q &> /dev/null; then
        # Using -i to ignore certificate errors (self-signed localhost) if q supports it or standard env vars
        # q usually detects protocol by URL scheme.
        if q "$TEST_DOMAIN" @"$DOH_URL" > /dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    else
        log "Error: 'q' command not found. Please install it (https://github.com/natesales/q)."
        exit 1
    fi
}

# Check if cloudflared is managed by systemd
if ! systemctl list-unit-files | grep -q cloudflared.service; then
    log "Error: cloudflared.service not found. Is it installed?"
    exit 1
fi

FAIL_COUNT=0
MAX_RETRIES=3

# Simple check logic: If fails, try again immediately up to MAX_RETRIES times
# If still fails, then consider it DOWN.

for (( i=1; i<=MAX_RETRIES; i++ )); do
    if check_dns; then
        # Success
        if ! systemctl is-active --quiet cloudflared; then
            log "DNS check PASSED. Starting cloudflared..."
            systemctl start cloudflared
        fi
        exit 0
    else
        # Fail
        log "DNS check attempt $i failed."
        sleep 2
    fi
done

# If we reached here, DNS is down
if systemctl is-active --quiet cloudflared; then
    log "DNS check FAILED after $MAX_RETRIES attempts. Stopping cloudflared to divert traffic."
    systemctl stop cloudflared
else
    log "DNS check FAILED. Cloudflared is already stopped."
fi

exit 1
