#!/bin/bash

output=$(iwgetid -r)

if [[ $output == "ibbWiFi" ]]; then
    nc -zw1 google.com 443;
    if [ $? -eq 0 ]; then
        echo "Online" >> /var/log/ibbwifi-autologin.log
    else
        echo "Trying to login..." >> /var/log/ibbwifi-autologin.log
        python3 /home/typefe/Desktop/w/PYTHON/Exercise/captive_auto_login/script.py
    fi
else
    echo "Not connected to ibbWifi, captive_login stopping to work." >> /var/log/ibbwifi-autologin.log
fi

