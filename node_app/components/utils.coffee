
fs = require 'fs'
request = require 'request'
config = require('../config/environment')
require 'shelljs/global'

download = (uri, filename, callback) ->
  request.head uri, (err, res, body) ->
    request(uri)
    .pipe(fs.createWriteStream(config.imageDirPath + filename))
    .on 'close', ->
      console.log "File #{filename} has been saved"
      callback()

restartRaspberryPi = ->
  if config.env is 'production'
    if exec("sh #{config.root + config.restartRaspberryPi}").code isnt 0
      console.log "Error: could not restart the Pi"

startSlideShow = (filenames) ->
  filePaths =
    filenames?.map (filename) ->
      "#{config.imageDirPath + filename}"
    .join(" ")
  if config.env is 'production'
    script = [
      "export INTERVAL=#{config.slideshowInterval}"
      "export IMAGE_DIR=#{config.imageDirPath}"
      "sh #{config.root + config.stopSlideshowScript}"
      "sh #{config.root + config.startSlideshowScript} #{filePaths ?= ""}"
    ].join(' && ')
    if exec(script).code isnt 0
      console.log "Error: could not start slideshow"

module.exports =
  download: download
  startSlideShow: startSlideShow
  restartRaspberryPi: restartRaspberryPi
