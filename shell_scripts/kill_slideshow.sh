#!/usr/bin/env bash

# PID=`ps aux | grep "fbi -T 2 -d /dev/fb1" | awk '{print $2}'`

pid=$(pgrep fbi)
if [ ! -z "$pid" ]; then
  echo | sudo kill $pid
fi
