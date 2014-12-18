#!/usr/bin/env bash

ping -c4 google.com > /dev/null

if [ $? != 0 ]
then
  echo | sudo /sbin/shutdown -r now
fi
