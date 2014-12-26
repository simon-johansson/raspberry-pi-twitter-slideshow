# Raspberry Pi Twitter Slideshow

Twitter bot that is meant to be run on a Raspberry Pi with an external screen. Uses twitter streaming API to look for tweets containing certain keywords, downloads images from those tweets and presents them in the form of a slideshow.

Written with Node.js, Coffeescript and Bash.


## Motivation

Used as a Christmas hack with the goal of opting out of the whole xmas card sending shenanigans. A gingerbread-hand holding a frosting-phone was built around a Raspberry Pi connected to a tiny screen. Instead of postcards, friends and family could send christmas tweets to us with an attached image. The image would then be downloaded and displayed on the “phone”.

![](https://pbs.twimg.com/media/B5LH7l9IEAATIMH.jpg:small)
![](https://pbs.twimg.com/media/B5LH7sVIgAEFY1b.jpg:small)

I also built in auto reply functionality but twitter blocks automated @replies and mentions done through their API. Which seems reasonable now that I think about it. 

## Installation

####Dev computer

	npm install grunt-cli coffee-script -g
	npm install

Rename `secrets.json.example` to `secrets.json` and fill it with the appropriate secrets. App configurations are kept in `environment/config/`

To compile the `.coffee` files into the `dist/` folder and continue to watch for changes, run:

	grunt 

Use the compiled version to run the app. Otherwise the paths will not work.


####Raspberry Pi

I used the [PITFT - 320X240 2.8" TFT+TOUCHSCREEN]( http://www.adafruit.com/product/1601) from adafruit to display images. They also supplied a raspbian based image, preconfigured for the PITFT screen. Can be found [here](https://learn.adafruit.com/adafruit-pitft-28-inch-resistive-touchscreen-display-raspberry-pi/easy-install).

[Install node.js and npm on your Raspberry Pi](http://joshondesign.com/2013/10/23/noderpi)

The [forever](https://github.com/nodejitsu/forever) module is used to ensuring that the app runs continuously, even after the SSH session has ended.	

	npm install forever -g
	
You will also need to install [fbi image viewer](http://manpages.ubuntu.com/manpages/utopic/man1/fbi.1.html), used to start the slideshow.

	sudo apt-get install fbi

If you use a wi-fi dongle then you probably want to restart the RasPi if it looses connection. This can be done with the `check_wifi.sh` script, set it up like this.
	

	crontab -e
	*/5 * * * * <PATH TO SCRIPT>/check_wifi.sh >> /dev/null 2>&1


If you utilize the `check_wifi.sh` then it might also be a good idea to start the app on boot. Add a line to your [/etc/rc.local]( http://www.raspberrypi.org/documentation/linux/usage/rc-local.md) that points to the `on_startup.sh` script, use absolute paths. You will also need to configure `on_startup.sh` with paths that match your setup.

## Deployment

The Gruntfile contains a neat deploy script to get the app running on a Raspberry Pi connected to the same local network.

	grunt deploy

Will compile and move all needed files into `dist/` and then copy the contents of that folder into `/home/pi/` on the RasPi.

	grunt deploy:start

Will do the same as the above command but also install all node dependencies, set the appropriate env variables and start the app with forever.


## TODO:

* Show the actual tweet along with the image on the screen
* fbi image viewer does not support animated .gifs

## Tests

Nope

## License

The MIT License (MIT)

Copyright (c) 2014 Simon Johansson
