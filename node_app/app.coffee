
process.env.NODE_ENV = process.env.NODE_ENV or 'development'
config = require('./config/environment')
utils = require('./components/utils')
twitter = require('./components/twitter')

utils.startSlideShow()
twitter.streamClient.start(config.twitterSearchTerms)

console.log "App is rolling in #{config.env} mode"
console.log "Looking for tweets containing: #{config.twitterSearchTerms}"
