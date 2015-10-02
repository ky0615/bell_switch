fs = require "fs"
path = require 'path'

exec = require('child_process').exec
spawn = require('child_process').spawn

platform = process.platform

class Announce
  stream: null

  fileList:
    home:
      arraival: []
      departure: []

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
    fs.readdir './announce/home_arraival', (err, files)=>
      throw err if err
      fileList = []
      files
        .filter (file)=>
          return /.*\.(wav|wave|mp3)$/.test file
        .forEach (file)=>
          fileList.push file
      @fileList.home.arraival = fileList
      cb @fileList.home.arraival

    fs.readdir './announce/home_departure', (err, files)=>
      throw err if err
      fileList = []
      files
        .filter (file)=>
          return /.*\.(wav|wave|mp3)$/.test file
        .forEach (file)=>
          fileList.push file
      @fileList.home.departure = fileList
      cb @fileList.home.departure

  getFile: (id)=>
    return "./music/" + @fileList[id]



module.exports = Announce