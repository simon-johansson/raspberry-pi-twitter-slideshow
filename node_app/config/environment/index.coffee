path = require 'path'
_ = require 'lodash'

requiredProcessEnv = (name) ->
  unless process.env[name]
    throw new Error "You must set the #{name} environment variable"
  process.env[name]

# All configurations will extend these options
all =
  env: process.env.NODE_ENV
  root: path.normalize("#{__dirname}/../..")
  imageSize: 'small' #large, medium, small, thumb
  autoReplyToTweets: false
  replayMessage: (replayTo, postedImage) ->
    thankYou = "Thank you for your Christmas card, it will look great in our slideshow."
    greeting = "Merry Xmas and happy New Year! //Simon & Mimmi"
    if postedImage
      "@#{replayTo} #{thankYou} #{greeting}"
    else "@#{replayTo} #{greeting}"
  includeImageInReplay: true

# Export the config object based on the NODE_ENV
module.exports = _.merge(
  all,
  require "./#{process.env.NODE_ENV}" or {})
