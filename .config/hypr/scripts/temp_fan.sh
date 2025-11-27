#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

# Get CPU temperature using 'sensors' command
cpu_temp=$(sensors | awk '/CPUTIN:/ {gsub("\\+", "", $2); print $2}')
# Get GPU temperature using 'nvidia-smi' command
gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)"°C"
# Get fan speeds using 'sensors' command
fan1=$(sensors | awk '/fan1:/ {print $2,$3}')
fan2=$(sensors | awk '/fan2:/ {print $2,$3}')
fan3=$(sensors | awk '/fan3:/ {print $2,$3}')

if [ -z "$cpu_temp" ]; then
    cpu_temp="N/A"
fi
if [ -z "$gpu_temp" ]; then
    gpu_temp="N/A"
fi
if [ -z "$fan1" ]; then
    fan1="N/A"
fi
if [ -z "$fan2" ]; then
    fan2="N/A"
fi
if [ -z "$fan3" ]; then
    fan3="N/A"
fi

if [ $# -eq 0 ]; then
    echo -e "CPU: ${cpu_temp} GPU: ${gpu_temp} \u00B7 F1: ${fan1} F2: ${fan2} F3: ${fan3}"
fi
if [ $# -eq 1 ] && [ "$1" == "--json" ]; then
    echo "{\"CPU\": \"$cpu_temp\", \"GPU\": \"$gpu_temp\", \"F1\": \"$fan1\", \"F2\": \"$fan2\", \"F3\":\"$fan3\"}"
fi
if [ $# -eq 1 ] && [ "$1" == "--temp" ]; then
    echo -e "CPU: ${cpu_temp} GPU: ${gpu_temp}ºC"
fi
if [ $# -eq 2 ] && [ "$1" == "--temp" ] && [ "$2" == "--json" ]; then
    echo "{\"CPU\": \"$cpu_temp\", \"GPU\": \"$gpu_temp\"}"
fi
if [ $# -eq 1 ] && [ "$1" == "--fan" ]; then
    echo -e "F1: ${fan1} F2: ${fan2} F3: ${fan3}"
fi
if [ $# -eq 2 ] && [ "$1" == "--fan" ] && [ "$2" == "--json" ]; then
    echo "{\"F1\": \"$fan1\", \"F2\": \"$fan2\", \"F3\": \"$fan3\"}"
fi

# echo '{"ifname":"wlp3s0","ssid":"Stan","public_ip":"79.245.207.11","ipaddr":"192.168.2.192"}'