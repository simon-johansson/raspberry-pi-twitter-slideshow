async = require 'async'
Twitter = require 'node-twitter'
_ = require 'lodash'
config = require '../config/environment'
utils = require "./utils"
secrets = require "../secrets"

twitterRestClient = new Twitter.RestClient(_.values(secrets.twitter)...)
twitterStreamClient = new Twitter.StreamClient(_.values(secrets.twitter)...)

twitterStreamClient
  .on 'close', () ->
    console.log 'Connection closed.'
  .on 'end', () ->
    console.log 'End of Line.'
  .on 'error', (error) ->
    msg = if error.code then "#{error.code} #{error.message}" else error.message
    console.log "Error: #{msg}"
  .on 'tweet', (raw_tweet) ->
    new Tweet(raw_tweet)

class Tweet
  constructor: (tweet) ->
    @data = tweet
    @id = @data.id.toString()
    @byUser = @data.user.screen_name
    @containsImage = @data.extended_entities?
    if @containsImage
      @showImage()
    if config.autoReplyToTweets
      @replayToTweet()

  showImage: =>
    @extractImageData()
    @downloadImages (filenames) -> utils.startSlideShow filenames

  extractImageData: =>
    @images = @data.extended_entities.media.map (el) ->
      obj =
        url: "#{el.media_url}:#{config.imageSize}"
        filename: el.media_url.split('/').pop()

  downloadImages: (callback) =>
    self = @
    async.each @images, (image, clb) ->
      utils.download image.url, image.filename, -> clb()
    , (err, filenames) ->
      if err then console.log err
      else callback _.pluck self.images, 'filename'

  replayToTweet: =>
    replay =
      in_reply_to_status_id: @id
      status: config.replayMessage(@byUser, @containsImage)
    console.log replay
    twitterRestClient.statusesUpdate replay, (err) =>
      if err then console.log err
      else console.log "Posted reply to @#{@byUser}"

module.exports =
  streamClient: twitterStreamClient
