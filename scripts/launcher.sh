#!/bin/bash
options=""

case $1 in
	"--firefox") firefox ;;
	"--tor") torbrowser-launcher ;;
	"--signal") signal-desktop-beta ;;
	"--discord") discord ;;
	"--mirage") mirage ;;
	"--jitsi") jitsi ;;
	"--keepass") keepassxc ;;
	"--weather") xterm -hold -e weather ;;
	"--python") xterm -e python3 -q ;;
	"--r") xterm -e R -q ;;
	"--record") xterm -e record ;;
	"--poweroff") systemctl poweroff ;;
	"--stop") python3 ~/.config/awesome/scripts/stop.py ;;
esac

