#!/usr/bin/env bash

# : ${INTERVAL=30}
# : ${IMAGE_DIR='/home/pi/images'}
IMAGES=`find $IMAGE_DIR \( -iname "*.jpg" -or -iname "*.jpeg" -or -iname "*.gif" -or -iname "*.png" \)`

start_slide_show () {
  echo | sudo fbi -T 2 -t $INTERVAL -d /dev/fb1 -noverbose -a $1
}

if [ -f "$1" ]; then
  start_slide_show "$1 $IMAGES"
else
  start_slide_show "$IMAGES"
fi
