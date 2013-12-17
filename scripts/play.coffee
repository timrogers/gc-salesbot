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

  descriptions = 
    bell: 'FIGHT!'
    celebrate: 'Ceeeeeeeelebrate good times!'
    countdown: 'The clock begins...'
    timmy: 'Oh, Timmy Rogers...'
    blobbo: "https://gocardless.com/assets/home/team/matt@2x-c1a6b08b64348cd2d29906d50cd08c8a.jpg"
    darts: "*LADDISH CHANT*"
    timmy: "Oh, Timmy Rogers..."
    unbelievable: "Unbelievable Jeff!"
    applause: "*applause*"
    alan: "ALAN! ALAN! AL!"

  get_local_ip = ->
    os = require('os')
    interfaces = os.networkInterfaces()
    addresses = []
    for interface_name, addresses of interfaces
      for address in addresses
        if address.family == 'IPv4' && !address.internal
            addresses.push(address.address)
    addresses.join(", ")

  robot.respond /(.*)$/i, (msg) ->
  	unless msg.match[1] == "sounds" || msg.match[1] == "ip"
	    path_to_mp3 = path.resolve(dir, "#{msg.match[1]}.mp3")

	    fs.exists path_to_mp3, (exists) ->
	    	if exists
	    		stream = fs.createReadStream path_to_mp3
	    		pipe = stream.pipe(new lame.Decoder())
	    		pipe.on 'format', (format) ->
	    			this.pipe(new Speaker(format))

	    		if descriptions.hasOwnProperty(msg.match[1])
	    			msg.send descriptions[msg.match[1]]
	    		else
	    			msg.send "Playing sound #{msg.match[1]}..."
	    	else
	    		msg.send "Sound '#{msg.match[1]}' does not exist"

  robot.respond /ip/i, (msg) ->
    msg.send "My current local IP is #{get_local_ip()}."

  robot.respond /sounds/i, (msg) ->
  	filenames = fs.readdirSync(dir).map (filename) ->
  		without_extension filename
  	.join(", ")
  	msg.send "The following sounds are playable with 'salesbot <sound name>': #{filenames}"

