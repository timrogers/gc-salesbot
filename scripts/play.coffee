# Description:
#   Play sounds to make the sales team happy
#
# Commands:
#   hubot play <key> - play a sound on the Rapsberry Pi

module.exports = (robot) ->
  path = require('path')
  fs = require('fs')
  lame = require('lame')
  Speaker = require('speaker')
  _  = require('underscore')

  dir = path.resolve(__dirname, 'sounds')

  robot.respond /play (.*)$/i, (msg) ->
    stream = fs.createReadStream path.resolve(dir, "#{msg.match[1]}.mp3")
    pipe = stream.pipe(new lame.Decoder())
    pipe.on 'format', (format) ->
    	this.pipe(new Speaker(format))
    msg.send "Playing sound #{msg.match[1]}"

  robot.respond /sounds/i, (msg) ->
  	msg.send "The following sounds are available:"
  	_.each fs.readdirSync(dir), (file) ->
  		msg.send file

