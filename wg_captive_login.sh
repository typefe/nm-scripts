#!/bin/bash

output=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2)
wgStatus=$(ifconfig | grep -o "wgcf-profile")

if [[ $output == "yes:ibbWiFi" ]]; then
    nc -zw1 google.com 443;
    if [ $? -eq 0 ]; then
        echo "Online"
    else
        if [[ $wgStatus == "wgcf-profile" ]]; then
            echo "Wireguard is connected but no connection, might be need a captive login."
            echo "Disabling wg..."
            wg-quick down wgcf-profile
            echo "Trying to login..."
            python3 /home/typefe/Desktop/w/PYTHON/Exercise/captive_auto_login/script.py
            runuser -l typefe -c 'warp-cli connect'
            sleep 10
            wg-quick up wgcf-profile
            sleep 10
            runuser -l typefe -c 'warp-cli disconnect'
        else
            echo "Wireguard is not connected. Trying to login..."
            python3 /home/typefe/Desktop/w/PYTHON/Exercise/captive_auto_login/script.py
        fi
    fi

else
    echo "Not connected to ibbWifi, captive_login stopping to work."
fi
