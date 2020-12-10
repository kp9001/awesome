#!/bin/bash

sudo cp fehRand.sh /usr/bin/fehbgRand
sed 's/fehbg/fehbgRand/' ../rc.lua > tmp && mv tmp ../rc.lua

