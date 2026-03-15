#!/bin/bash

DOH_URL="http://127.0.0.1:8100/dns-query"
TEST_DOMAIN="google.com"
FAIL_THRESHOLD=3
LOG_FILE="/var/log/dns-watchdog.log"


TG_BOT_TOKEN=""
TG_CHAT_ID="-1001432960351"
TG_THREAD_ID="213263"
HOST_NAME="${HOSTNAME}"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

send_tg() {
    local message="$1"
    if command -v curl &> /dev/null; then
        curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
            -d chat_id="${TG_CHAT_ID}" \
            -d message_thread_id="${TG_THREAD_ID}" \
            -d text="${message}" > /dev/null
    else
        log "Warning: curl not found, cannot send Telegram notification."
    fi
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
# if ! systemctl cat cloudflared.service &> /dev/null; then
#     log "Error: cloudflared.service not found. Is it installed?"
#     exit 1
# fi

FAIL_COUNT=0
MAX_RETRIES=3

# Simple check logic: If fails, try again immediately up to MAX_RETRIES times
# If still fails, then consider it DOWN.

i=1
while [ "$i" -le "$MAX_RETRIES" ]; do
    if check_dns; then
        # Success
        if ! systemctl is-active --quiet cloudflared; then
            log "DNS check PASSED. Starting cloudflared..."
            send_tg "🟢 ${HOST_NAME} DNS check PASSED. Starting cloudflared..."
            systemctl start cloudflared
        fi
        exit 0
    else
        # Fail
        log "DNS check attempt $i failed."
        sleep 2
    fi
    i=$((i + 1))
done

# If we reached here, DNS is down
if systemctl is-active --quiet cloudflared; then
    log "DNS check FAILED after $MAX_RETRIES attempts. Stopping cloudflared to divert traffic."
    send_tg "🔴 ${HOST_NAME} DNS check FAILED after $MAX_RETRIES attempts. Stopping cloudflared to divert traffic."
    systemctl stop cloudflared
else
    log "DNS check FAILED. Cloudflared is already stopped."
fi

exit 1