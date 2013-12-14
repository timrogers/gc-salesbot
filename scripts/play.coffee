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

  without_extension = (f) -> f.split('.')[0]

  descriptions = {
  	"bell": "FIGHT!",
  	"celebrate": "Celeeeeeebrate good times!",
  	"countdown": "The clock begins...",
  	"darts": "*LADDISH CHANT*",
  	"fired": "http://i.dailymail.co.uk/i/pix/2009/03/26/article-1164849-041ABF68000005DC-138_468x286.jpg"
  }

  robot.respond /(.*)$/i, (msg) ->
  	unless msg.match[1] == "sounds"
	    path_to_mp3 = path.resolve(dir, "#{msg.match[1]}.mp3")

	    fs.exists path_to_mp3, (exists) ->
	    	if exists
	    		stream = fs.createReadStream path_to_mp3
	    		pipe = stream.pipe(new lame.Decoder())
	    		pipe.on 'format', (format) ->
	    			this.pipe(new Speaker(format))

	    		console.log msg.match[1]
	    		console.log descriptions

	    		if descriptions.hasOwnProperty(msg.match[1])
	    			msg.send descriptions[msg.match[1]]
	    		else
	    			msg.send "Playing sound #{msg.match[1]}..."
	    	else
	    		msg.send "Sound '#{msg.match[1]}' does not exist"

  robot.respond /sounds/i, (msg) ->
  	filenames = fs.readdirSync(dir).map (filename) ->
  		without_extension filename
  	.join(", ")
  	msg.send "The following sounds are playable with 'salesbot <sound name>': #{filenames}"

