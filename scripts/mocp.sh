#!/bin/bash
options=""

case $1 in
	"--search")
		options+="search"
		;;
	"--pause")
		options+="pause"
		;;
	"--play")
		options+="play"
		;;
	"--next")
		options+="next"
		;;
	"--previous")
		options+="previous"
		;;
	"--seek+")
		options+="seek+"
		;;
	"--seek-")
		options+="seek-"
		;;
esac

[ $options = "search" ] && xterm -e "cd ~/music && ranger"
[ $options = "pause" ] && mocp --toggle-pause
[ $options = "play" ] && mocp -S && mocp --play
[ $options = "next" ] && mocp --next
[ $options = "previous" ] && mocp --previous
[ $options = "seek+" ] && mocp --seek=10
[ $options = "seek-" ] && mocp --seek=-10

