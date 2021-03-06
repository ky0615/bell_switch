fs = require "fs"
path = require 'path'

config = require 'config'

exec = require('child_process').exec
spawn = require('child_process').spawn

platform = process.platform
console.log config
class Buzzer
  stream: null
  sound: config.buzzer_sound

  play: ()=>
    @stop() if @stream
    @isFile (exists)=>
      unless exists
        console.log "eidan buzzer is not found"
        return

      if /^darwin/.test platform
        @stream = spawn "afplay", [@sound]
      else
        @stream = spawn "aplay", ["-D", "plughw:0", @sound]

  playDuration: ()=>
    setTimeout ()=>
      @play file
    , 500

  stop: ()->
    unless @stream
      return
    if /^darwin/.test platform
      exec "kill " + @stream.pid
    else
      @stream.kill "SIGTERM"
      @stream.emit "stop"
    @stream = null

  isFile: (callback)->
    fs.exists @sound, callback

module.exports = Buzzer
