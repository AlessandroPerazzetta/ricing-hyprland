#!/bin/bash

# --- Robust Interface Detection ---
# Finds the interface used for the default gateway
INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

# Fallback: if no default route, try to find any active wireless or ethernet
if [ -z "$INTERFACE" ]; then
    INTERFACE=$(nmcli -t -f DEVICE,STATE device | grep ":connected" | cut -d: -f1 | head -n1)
fi

# --- Get Network Speeds (with error handling) ---
if [ -n "$INTERFACE" ] && [ -d "/sys/class/net/$INTERFACE" ]; then
    R1=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
    T1=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)
    sleep 1
    R2=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
    T2=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)
    RX=$(( (R2 - R1) / 1024 ))
    TX=$(( (T2 - T1) / 1024 ))
else
    RX=0
    TX=0
fi

# --- Get Other Stats ---
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
DISK=$(df -h / | awk '/\// {print $4}')
IP=$(ip addr show "$INTERFACE" 2>/dev/null | grep "inet " | awk '{print $2}' | head -n1)
[ -z "$IP" ] && IP="No IP"
SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
[ -z "$SSID" ] && SSID="Ethernet/None"

# --- Format Tooltip ---
# We use \r to help with potential parsing issues and double-escape backslashes
#TOOLTIP="<span color='#7aa2f7'>󰖩 Net:</span> $SSID\n"
#TOOLTIP+="<span color='#e0af68'>󰩟 IP:</span> $IP\n"
#TOOLTIP+="<span color='#9ece6a'>󰇚 RX:</span> ${RX}KB/s  <span color='#f7768e'>󰇛 TX:</span> ${TX}KB/s\n"
#TOOLTIP+="<span color='#444b6a'>---------------------------</span>\n"
#TOOLTIP+="<span color='#ad8ee6'>󰍛 Mem:</span> $MEM\n"
#TOOLTIP+="<span color='#e0af68'>󟡔 Disk:</span> $DISK free"
# Temporarily change this in sysinfo.sh to test:
TOOLTIP="Net: $SSID\nIP: $IP\nRX: ${RX}KB/s TX: ${TX}KB/s\nMem: $MEM\nDisk: $DISK"

# --- Clean JSON Output ---
# Using printf ensures no accidental newlines break the JSON string
#printf '{"text": "󰻠 %s", "tooltip": "%s"}\n' "$CPU" "$TOOLTIP"

# ... existing script logic ...

# Use a clean variable for the text field to ensure no special chars break it
BAR_TEXT="󰻠 $CPU"

# Explicitly build the JSON string
echo "{\"text\": \"$BAR_TEXT\", \"tooltip\": \"$TOOLTIP\"}"
