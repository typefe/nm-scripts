#!/bin/bash

output=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2)
warpStatus=$(warp-cli status | awk -F 'Status update: ' '{print $2}' | tr -d "\n")

nc -zw1 google.com 443;

if [ $? -eq 0 ]; then
    echo "Online"
else
    echo -e "Status Offline...\nChecking ibbWifi connection."
    if [[ $output == "yes:ibbWiFi" ]]; then
        echo "ibbWifi connection dedected. Checking Warp status..."
        if [[ $warpStatus != "Disconnected. Reason: Manual Disconnection" ]]; then
            echo "Warp is connected but no connection, might be need a captive login."
            echo "Disabling Warp..."
            warp-cli disconnect
            echo "Trying to login..."
            python3 /home/typefe/Desktop/w/PYTHON/Exercise/captive_auto_login/script.py
            warp-cli connect
        else
            echo "Warp is not connected. Trying to login..."
            python3 /home/typefe/Desktop/w/PYTHON/Exercise/captive_auto_login/script.py
        fi
    else
        echo "Not connected to ibbWifi, captive_login stopping to work."
    fi
fi


