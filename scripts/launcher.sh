#!/bin/bash
options=""

case $1 in
	"--firefox")
		options+="firefox"
		;;
	"--tor")
		options+="tor"
		;;
	"--signal")
		options+="signal"
		;;
	"--discord")
		options+="discord"
		;;
	"--element")
		options+="element"
		;;
	"--keepass")
		options+="keepass"
		;;
	"--stop")
		options+="stop"
		;;
	"--poweroff")
		options+="poweroff"
		;;
esac

echo "$options"

[ $options = "firefox" ] && /opt/firefox/firefox 
[ $options = "tor" ] && torbrowser-launcher
[ $options = "signal" ] && signal-desktop --no-sandbox
[ $options = "discord" ] && discord
[ $options = "element" ] && element-desktop
[ $options = "keepass" ] && keepassxc
[ $options = "stop" ] && python3 ~/documents/scripts/miscellaneous/stop.py
[ $options = "poweroff" ] && systemctl poweroff

