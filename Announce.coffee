fs = require "fs"
path = require 'path'

exec = require('child_process').exec
spawn = require('child_process').spawn

platform = process.platform

class Announce
  stream: null

  fileList: []
  departureFileList: []
  nowDID: 0

  autoPlay: 1

  play: (file)->
    @stop() if @stream
    if /^darwin/.test platform
      @stream = spawn "afplay", [file]
    else
      @stream = spawn "aplay", [file]

  stop: ()->
    unless @stream
      return
    if /^darwin/.test platform
      exec "kill " + @stream.pid
    else
      @stream.kill "SIGTERM"
      @stream.emit "stop"
    @stream = null

  getFileList: (cb)=>
    @fileList = []
    fs.readdirSync './announce'
      .map (file)=> path.join "./announce", file
      .filter (file)=> fs.statSync(file).isDirectory()
      .forEach (dir)=>
        fs.readdirSync dir
          .filter (file)-> /.*\.(wav|wave|mp3)$/.test file
          .map (file)-> path.join dir, file
          .forEach (file)=>
            @fileList.push file
    @departureFileList = @fileList.filter (file)-> file.split("/")[1] is "home_departure"
    cb @fileList

  getFile: (id)=>
    return @fileList[id]

  getDepartureFile: (id)=>
    return @departureFileList[id]

module.exports = Announce