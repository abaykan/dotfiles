#!/bin/bash
# memu-connect.sh - Connect ADB from MSI to MEmu emulator on ASUS
#
# Usage:
#   ./memu-connect.sh              # Connect ADB only
#   ./memu-connect.sh proxy-on     # Enable Burp proxy on emulator
#   ./memu-connect.sh proxy-off    # Disable proxy on emulator
#   ./memu-connect.sh status       # Show current status
#
# === SETUP REQUIREMENTS ===
#
# 1. ASUS LAPTOP (MEmu host):
#    - Install OpenSSH Server:
#      Settings > Apps > Optional Features > Add "OpenSSH Server"
#    - Start SSH service (CMD as Admin):
#      net start sshd
#    - Set network profile to Private (CMD as Admin):
#      powershell -c "Set-NetConnectionProfile -InterfaceAlias 'Wi-Fi' -NetworkCategory Private"
#    - MEmu emulator must be running
#
# 2. MSI LAPTOP (pentest machine):
#    - Install ADB:
#      sudo apt install adb
#    - SSH key-based auth to ASUS (optional but recommended):
#      ssh-copy-id abay@<ASUS_IP>
#    - Allow Burp port through firewall:
#      sudo ufw allow 1337/tcp
#
# 3. BURP SUITE:
#    - Proxy > Options > Proxy Listeners
#    - Edit listener > Binding > Bind to address: All interfaces
#    - Set port to 1337 (or update BURP_PORT below)
#    - Disable SOCKS proxy if enabled:
#      User options > Connections > SOCKS Proxy > remove/disable
#
# 4. NETWORK:
#    - Both laptops must be on the same WiFi/subnet
#    - ASUS IP auto-detected via MAC address or known IPs
#    - If ASUS IP changes, add new IP to ASUS_KNOWN_IPS below
#
# === TROUBLESHOOTING ===
#
# - "ASUS not found": Check WiFi, ping ASUS manually
# - "Cannot SSH": Check OpenSSH service, network profile (Private)
# - "ADB offline": MEmu might need restart, reconnect tunnel
# - "No response in Burp": Check SOCKS proxy is disabled in Burp
# - "Connection refused on browser": Check firewall ufw allow 1337/tcp

set -e

# --- Config ---
ASUS_MAC="f4:8c:50:ad:77:ad"
ASUS_USER="abay"
ASUS_KNOWN_IPS=("192.168.31.210" "192.168.1.35")
MEmu_PORT="21513"
LOCAL_ADB_PORT="21513"
BURP_PORT="1337"
ADB_DEVICE="127.0.0.1:${LOCAL_ADB_PORT}"

# Auto-detect MSI IP (Burp host)
find_msi_ip() {
    ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}' | head -1
}
BURP_HOST=$(find_msi_ip)

# --- Functions ---

find_asus_ip() {
    local ip
    # Try MAC lookup first (works on same subnet)
    ip=$(ip neigh show | grep -i "$ASUS_MAC" | grep -v FAILED | awk '{print $1}' | head -1)
    if [ -z "$ip" ]; then
        ip=$(arp -an 2>/dev/null | grep -i "$ASUS_MAC" | awk '{print $2}' | tr -d '()' | head -1)
    fi
    # Fallback: try known IPs
    if [ -z "$ip" ]; then
        for known_ip in "${ASUS_KNOWN_IPS[@]}"; do
            if ping -c 1 -W 1 "$known_ip" &>/dev/null; then
                # Verify it's actually ASUS by checking SSH
                if ssh -o ConnectTimeout=2 -o BatchMode=yes "$ASUS_USER@$known_ip" "hostname" 2>/dev/null | grep -qi asus; then
                    ip="$known_ip"
                    break
                fi
            fi
        done
    fi
    echo "$ip"
}

check_tunnel() {
    ss -tlnp 2>/dev/null | grep -q "127.0.0.1:${LOCAL_ADB_PORT}" && return 0
    netstat -tlnp 2>/dev/null | grep -q ":${LOCAL_ADB_PORT}" && return 0
    return 1
}

check_adb() {
    timeout 3 adb devices 2>/dev/null | grep -q "${ADB_DEVICE}.*device" && return 0
    return 1
}

do_connect() {
    local asus_ip
    asus_ip=$(find_asus_ip)
    if [ -z "$asus_ip" ]; then
        echo "[!] ASUS not found on network. Check if ASUS is on and connected to WiFi."
        echo "    MAC: $ASUS_MAC"
        exit 1
    fi
    echo "[*] ASUS found at: $asus_ip"

    if ! ssh -o ConnectTimeout=3 -o BatchMode=yes "$ASUS_USER@$asus_ip" "echo ok" &>/dev/null; then
        echo "[!] Cannot SSH to $ASUS_USER@$asus_ip"
        exit 1
    fi
    echo "[*] SSH connection OK"

    if check_tunnel; then
        echo "[*] Tunnel already exists on port $LOCAL_ADB_PORT"
    else
        echo "[*] Creating SSH tunnel: localhost:$LOCAL_ADB_PORT -> $asus_ip:$MEmu_PORT"
        ssh -f -N -L "${LOCAL_ADB_PORT}:127.0.0.1:${MEmu_PORT}" "$ASUS_USER@$asus_ip"
        sleep 1
        if ! check_tunnel; then
            echo "[!] Failed to create tunnel"
            exit 1
        fi
        echo "[*] Tunnel created"
    fi

    if check_adb; then
        echo "[*] ADB already connected: $ADB_DEVICE"
    else
        echo "[*] Connecting ADB..."
        timeout 5 adb connect "$ADB_DEVICE" 2>/dev/null
        sleep 1
        if check_adb; then
            echo "[*] ADB connected: $ADB_DEVICE"
        else
            echo "[!] ADB connection failed"
            exit 1
        fi
    fi

    local model
    model=$(timeout 5 adb -s "$ADB_DEVICE" shell getprop ro.product.model 2>/dev/null || echo "unknown")
    echo "[*] Device: $model"
    echo ""
    echo "[OK] Ready! Use 'adb -s $ADB_DEVICE shell' to interact."
}

do_proxy_on() {
    if ! check_adb; then
        echo "[!] ADB not connected. Run '$0' first."
        exit 1
    fi

    echo "[*] Setting proxy: $BURP_HOST:$BURP_PORT"
    timeout 5 adb -s "$ADB_DEVICE" shell settings put global global_http_proxy_host "$BURP_HOST"
    timeout 5 adb -s "$ADB_DEVICE" shell settings put global global_http_proxy_port "$BURP_PORT"
    timeout 5 adb -s "$ADB_DEVICE" shell settings put global http_proxy "${BURP_HOST}:${BURP_PORT}"
    echo "[OK] Proxy enabled -> $BURP_HOST:$BURP_PORT"
}

do_proxy_off() {
    if ! check_adb; then
        echo "[!] ADB not connected. Run '$0' first."
        exit 1
    fi

    echo "[*] Disabling proxy..."
    timeout 5 adb -s "$ADB_DEVICE" shell settings put global http_proxy :0
    timeout 5 adb -s "$ADB_DEVICE" shell settings delete global global_http_proxy_host
    timeout 5 adb -s "$ADB_DEVICE" shell settings delete global global_http_proxy_port
    echo "[OK] Proxy disabled"
}

do_status() {
    local asus_ip
    asus_ip=$(find_asus_ip)
    echo "=== MEmu Connect Status ==="
    echo "ASUS IP:    ${asus_ip:-not found}"
    echo "ASUS MAC:   $ASUS_MAC"
    echo "Tunnel:     $(check_tunnel && echo "active (port $LOCAL_ADB_PORT)" || echo "inactive")"
    echo "ADB:        $(check_adb && echo "connected ($ADB_DEVICE)" || echo "disconnected")"

    if check_adb; then
        local model proxy_host proxy_port
        model=$(timeout 5 adb -s "$ADB_DEVICE" shell getprop ro.product.model 2>/dev/null || echo "unknown")
        proxy_host=$(timeout 5 adb -s "$ADB_DEVICE" shell settings get global global_http_proxy_host 2>/dev/null)
        proxy_port=$(timeout 5 adb -s "$ADB_DEVICE" shell settings get global global_http_proxy_port 2>/dev/null)
        echo "Device:     $model"
        if [ -n "$proxy_host" ] && [ "$proxy_host" != "null" ]; then
            echo "Proxy:      $proxy_host:$proxy_port"
        else
            echo "Proxy:      off"
        fi
    fi
}

# --- Main ---
case "${1:-connect}" in
    connect|"")
        do_connect
        ;;
    proxy-on)
        do_proxy_on
        ;;
    proxy-off)
        do_proxy_off
        ;;
    status)
        do_status
        ;;
    help)
        # Show setup info (lines between SETUP REQUIREMENTS and end of comments)
        sed -n '/^# === SETUP REQUIREMENTS/,/^set -e/{/^# ===/p; /^#$/p; /^# /p;}' "$0"
        ;;
    *)
        echo "Usage: $0 {connect|proxy-on|proxy-off|status|help}"
        exit 1
        ;;
esac
