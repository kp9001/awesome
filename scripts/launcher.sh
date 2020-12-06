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
	"--lutris")
		options+="lutris"
		;;
	"--python")
		options+="python"
		;;
	"--r")
		options+="r"
		;;
	"--record")
		options+="record"
		;;
	"--poweroff")
		options+="poweroff"
		;;
	"--stop")
		options+="stop"
		;;
esac

[ $options = "firefox" ] && firefox
[ $options = "tor" ] && torbrowser-launcher
[ $options = "signal" ] && signal-desktop --no-sandbox
[ $options = "discord" ] && discord
[ $options = "element" ] && element-desktop
[ $options = "keepass" ] && keepassxc
[ $options = "lutris" ] && lutris
[ $options = "python" ] && xterm -e python3 -q
[ $options = "r" ] && xterm -e R -q
[ $options = "record" ] && xterm -e record
[ $options = "poweroff" ] && systemctl poweroff

## This is some nonsense I wrote. It's not important at all. 
## But if you want to use it, it is included and will run if you install python3 and pynput 
## (or just python and rewrite the command).
[ $options = "stop" ] && python3 ~/.config/awesome/scripts/stop.py 

