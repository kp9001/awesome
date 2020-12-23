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
	"--mirage")
		options+="mirage"
		;;
	"--jitsi")
		options+="jitsi"
		;;
	"--keepass")
		options+="keepass"
		;;
	"--weather")
		options+="weather"
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
[ $options = "signal" ] && signal-desktop-beta
[ $options = "discord" ] && discord
[ $options = "mirage" ] && mirage
[ $options = "jitsi" ] && jitsi
[ $options = "keepass" ] && keepassxc
[ $options = "weather" ] && xterm -hold -e weather
[ $options = "python" ] && xterm -e python3 -q
[ $options = "r" ] && xterm -e R -q
[ $options = "record" ] && xterm -e record
[ $options = "poweroff" ] && systemctl poweroff

## This is some nonsense I wrote. It's not important at all. 
## But if you want to use it, it is included and will run if you install python3 and pynput 
## (or just python and rewrite the command).
[ $options = "stop" ] && python3 ~/.config/awesome/scripts/stop.py 

