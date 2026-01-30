#!/bin/bash

# Supports Ubuntu/Debian/CentOS/RHEL

set -e

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERR]${NC} $1"; }

# --- Check Root ---
if [ "$EUID" -ne 0 ]; then
  log_err "Please run as root"
  exit 1
fi

# --- Global Vars ---
INSTALL_DIR="/opt/adguardhome"
SYNC_VERSION="v0.6.0" # Example version, will try to fetch latest if possible
ARCH=$(uname -m)

# --- Functions ---

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        log_err "Cannot detect OS. Exiting."
        exit 1
    fi
}

install_dependencies() {
    log_info "Installing dependencies..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        apt-get update -qq
        apt-get install -y curl wget tar dnsutils
    elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS" == "fedora" ]]; then
        if command -v dnf &> /dev/null; then
            dnf install -y curl wget tar bind-utils
        else
            yum install -y curl wget tar bind-utils
        fi
    else
        log_err "Unsupported OS: $OS"
        exit 1
    fi
}

install_tailscale() {
    if command -v tailscale &> /dev/null; then
        log_info "Tailscale already installed."
    else
        log_info "Installing Tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
    fi
    log_info "Please ensure you run 'tailscale up' after installation completes if not already authenticated."
}

install_cloudflared() {
    if command -v cloudflared &> /dev/null; then
        log_info "Cloudflared already installed."
    else
        log_info "Installing Cloudflared..."
        # Simplified install logic. For robust production, use official repo.
        # This uses the binary download which is cross-distro compatible but harder to update.
        # Recommendation: Use package manager if possible.
        
        # Trying package manager first
        if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
            curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
            dpkg -i cloudflared.deb
            rm cloudflared.deb
        elif [[ "$OS" == "centos" || "$OS" == "rhel" ]]; then
            curl -L --output cloudflared.rpm https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
            rpm -ivh cloudflared.rpm
            rm cloudflared.rpm
        else
             log_warn "Manual binary install for $OS..."
             wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
             chmod +x /usr/local/bin/cloudflared
        fi
    fi
}

install_q() {
    if command -v q &> /dev/null; then
        log_info "'q' DNS client already installed."
    else
        log_info "Installing 'q' DNS client..."
        # Fetch latest release for linux amd64
        # Assumes tar.gz release structure
        curl -sL https://github.com/natesales/q/releases/latest/download/q_linux_amd64.tar.gz -o q.tar.gz
        tar xvf q.tar.gz q
        mv q /usr/local/bin/q
        chmod +x /usr/local/bin/q
        rm q.tar.gz
        log_info "'q' installed."
    fi
}


install_adguardhome() {
    if [ -f "$INSTALL_DIR/AdGuardHome" ]; then
        log_info "AdGuard Home already installed in $INSTALL_DIR"
    else
        log_info "Installing AdGuard Home..."
        mkdir -p "$INSTALL_DIR"
        cd "$INSTALL_DIR"
        
        # Download latest
        curl -s -L https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz -o AdGuardHome.tar.gz
        tar xvf AdGuardHome.tar.gz --strip-components=1
        rm AdGuardHome.tar.gz
        
        # Install Service
        ./AdGuardHome -s install
        log_info "AdGuard Home Service Installed."
    fi
}

setup_watchdog() {
    log_info "Setting up DNS Watchdog..."
    cp "$PWD/dns-watchdog.sh" /usr/local/bin/dns-watchdog.sh
    chmod +x /usr/local/bin/dns-watchdog.sh
    
    # Create Service
    cat <<EOF > /etc/systemd/system/dns-watchdog.service
[Unit]
Description=AdGuard Home DNS Watchdog
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/dns-watchdog.sh
EOF

    # Create Timer
    cat <<EOF > /etc/systemd/system/dns-watchdog.timer
[Unit]
Description=Run DNS Watchdog every 30 seconds

[Timer]
OnBootSec=1min
OnUnitActiveSec=30s
Unit=dns-watchdog.service

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable --now dns-watchdog.timer
    log_info "DNS Watchdog Timer Enabled."
}

setup_replica_sync() {
    log_info "Setting up AdGuardHome Sync..."
    
    # Install Binary
    # Only supporting AMD64 for simplicity in this script, adjust for ARM if needed
    local url="https://github.com/bakito/adguardhome-sync/releases/latest/download/adguardhome-sync-linux-amd64"
    curl -L -o /usr/local/bin/adguardhome-sync "$url"
    chmod +x /usr/local/bin/adguardhome-sync
    
    mkdir -p /etc/adguardhome-sync
    
    read -p "Enter Primary (Master) AdGuard URL (e.g. http://100.x.y.z:80): " ORIGIN_URL
    read -p "Enter Primary Username: " ORIGIN_USER
    read -s -p "Enter Primary Password: " ORIGIN_PASS
    echo ""
    
    # Create Config
    cat <<EOF > /etc/adguardhome-sync/adguardhome-sync.yaml
api:
  origin:
    url: "$ORIGIN_URL"
    username: "$ORIGIN_USER"
    password: "$ORIGIN_PASS"
  replica:
    url: "http://127.0.0.1:80" # Localhost
    username: "$ORIGIN_USER" # Assuming same creds for simplicity, or ask user?
    password: "$ORIGIN_PASS"
cron: "*/1 * * * *" # Sync every minute
runOnStart: true
EOF
    
    # Create Service
    cat <<EOF > /etc/systemd/system/adguardhome-sync.service
[Unit]
Description=AdGuardHome Sync Service
After=network.target

[Service]
ExecStart=/usr/local/bin/adguardhome-sync run --config /etc/adguardhome-sync/adguardhome-sync.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now adguardhome-sync
    log_info "AdGuardHome Sync Service Enabled."
}

# --- Main Flow ---

detect_os
install_dependencies

echo "Select Node Role:"
echo "1) Primary (Master)"
echo "2) Replica (Slave)"
read -p "Choice [1/2]: " role

install_tailscale
install_cloudflared
install_q
install_adguardhome
setup_watchdog

if [ "$role" == "2" ]; then
    setup_replica_sync
fi

log_info "Installation Complete!"
log_info "1. Configure AdGuard Home at http://YOUR_IP:3000"
log_info "2. Run 'cloudflared tunnel login' and 'cloudflared tunnel create <NAME>' if not done."
log_info "3. If Replica, check 'systemctl status adguardhome-sync' logs."
