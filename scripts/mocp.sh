#!/bin/bash
options=""

case $1 in
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
esac

[ $options = "pause" ] && mocp --toggle-pause
[ $options = "play" ] && mocp --play
[ $options = "next" ] && mocp --next
[ $options = "previous" ] && mocp --previous

