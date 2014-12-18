
# Production specific configuration
module.exports =
  imageDirPath: "/home/pi/images/"
  startSlideshowScript: '/shell_scripts/start_slideshow.sh'
  stopSlideshowScript: '/shell_scripts/kill_slideshow.sh'
  restartRaspberryPi: '/shell_scripts/restart_raspberry_pi.sh'
  slideshowInterval: '60'
  twitterSearchTerms: ['@SimonOchMimmi']

