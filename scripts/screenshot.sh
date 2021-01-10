#!/bin/bash
DIR=$HOME/pictures/.screenshots
TIME=`date +%Y-%m-%d-%H-%M-%S`
IMAGE=$DIR"/"$TIME".png"
OPTIONS=""

case $1 in
	"--select") OPTIONS+="-s" ;;
	"--active") OPTIONS+="-i $(xdotool getactivewindow)" ;;
esac

[ ! -d $DIR ] && mkdir -p $DIR
maim --hidecursor $OPTIONS $IMAGE
xclip -i $IMAGE -selection clipboard -t image/png

