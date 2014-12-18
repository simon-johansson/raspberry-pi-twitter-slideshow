#!/usr/bin/env bash

export NODE_ENV=production
forever=/home/pi/node-v0.10.26-linux-arm-pi/bin/forever
$forever start /home/pi/raspberrypi_twitter_slideshow/app.js
